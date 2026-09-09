package tech.peny.pos_printer;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.app.Activity;
import android.device.PrinterManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/** PosPrinterPlugin */
public class PosPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String TAG = "PosPrinterPlugin";
  
  /// The MethodChannel that will the communication between Flutter and native Android
  private MethodChannel channel;
  private PrinterManager mPrinterManager;
  private boolean isPrinterInitialized = false;

  // Printing blocks until the page is done, so page-commit calls run off the
  // platform thread on a single HandlerThread (its own Looper, in case the SDK
  // posts internally). Single thread => commits run in the order Dart made them.
  private HandlerThread printThread;
  private Handler printHandler;
  private final Handler mainHandler = new Handler(Looper.getMainLooper());

  // ponytail: fixed 3-try BUSY backoff, 300ms apart. Widen if slow devices report false BUSY.
  private final static int PRINT_MAX_TRIES = 3;
  private final static long PRINT_BUSY_DELAY_MS = 300;

  private interface PrintOp {
    int run(PrinterManager pm);
  }

  /**
   * Runs a page-commit off the platform thread: checks printer status (retrying
   * while BUSY), runs the op if OK, and replies on the platform thread with the
   * resulting PRNSTS_* code. Any value other than PRNSTS_OK means nothing printed.
   */
  private void commitAsync(final Result result, final PrintOp op) {
    printHandler.post(new Runnable() {
      @Override
      public void run() {
        final Object reply;
        try {
          PrinterManager pm = getPrinterManager();
          if (pm == null) {
            postError(result, "PRINTER_ERROR", "Printer not initialized");
            return;
          }
          int status = pm.getStatus();
          for (int tries = 1; status == PRNSTS_BUSY && tries < PRINT_MAX_TRIES; tries++) {
            try {
              Thread.sleep(PRINT_BUSY_DELAY_MS);
            } catch (InterruptedException e) {
              Thread.currentThread().interrupt();
            }
            status = pm.getStatus();
          }
          reply = (status == PRNSTS_OK) ? op.run(pm) : status;
        } catch (final Exception ex) {
          postError(result, "PRINTER_ERROR", ex.getMessage());
          return;
        }
        mainHandler.post(new Runnable() {
          @Override
          public void run() {
            result.success(reply);
          }
        });
      }
    });
  }

  private void postError(final Result result, final String code, final String message) {
    mainHandler.post(new Runnable() {
      @Override
      public void run() {
        result.error(code, message, null);
      }
    });
  }

  // Printer configuration constants
  private final static int DEF_PRINTER_HUE_VALUE = 0;
  private final static int MIN_PRINTER_HUE_VALUE = 0;
  private final static int MAX_PRINTER_HUE_VALUE = 4;

  private final static int DEF_PRINTER_SPEED_VALUE = 9;
  private final static int MIN_PRINTER_SPEED_VALUE = 0;
  private final static int MAX_PRINTER_SPEED_VALUE = 9;

  // Printer status constants
  private final static int PRNSTS_OK = 0;                // OK
  private final static int PRNSTS_OUT_OF_PAPER = -1;     // Out of paper
  private final static int PRNSTS_OVER_HEAT = -2;        // Over heat
  private final static int PRNSTS_UNDER_VOLTAGE = -3;    // Under voltage
  private final static int PRNSTS_BUSY = -4;             // Device is busy
  private final static int PRNSTS_ERR = -256;            // Common error
  private final static int PRNSTS_ERR_DRIVER = -257;     // Driver error

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "pos_printer");
    channel.setMethodCallHandler(this);
    printThread = new HandlerThread("pos_printer");
    printThread.start();
    printHandler = new Handler(printThread.getLooper());
    Log.d(TAG, "PosPrinterPlugin attached to engine");
  }

  /**
   * Get or create PrinterManager instance with proper initialization
   */
  private synchronized PrinterManager getPrinterManager() {
    if (mPrinterManager == null) {
      try {
        Log.d(TAG, "Initializing PrinterManager");
        mPrinterManager = new PrinterManager();
        int openResult = mPrinterManager.open();
        if (openResult == 0) {
          isPrinterInitialized = true;
          Log.d(TAG, "PrinterManager initialized successfully");
        } else {
          Log.e(TAG, "Failed to open PrinterManager, result: " + openResult);
          isPrinterInitialized = false;
        }
      } catch (Exception e) {
        Log.e(TAG, "Error initializing PrinterManager", e);
        isPrinterInitialized = false;
      }
    }
    return mPrinterManager;
  }

  /**
   * Check if printer is ready for operations
   */
  private boolean isPrinterReady() {
    if (!isPrinterInitialized || mPrinterManager == null) {
      Log.w(TAG, "Printer not initialized");
      return false;
    }
    
    int status = mPrinterManager.getStatus();
    if (status != PRNSTS_OK) {
      Log.w(TAG, "Printer not ready, status: " + status);
      return false;
    }
    
    return true;
  }

  /**
   * Validate printer parameters
   */
  private boolean validateParameters(Map<String, Object> arguments, String... requiredParams) {
    if (arguments == null) {
      Log.e(TAG, "Arguments cannot be null");
      return false;
    }
    
    for (String param : requiredParams) {
      if (!arguments.containsKey(param)) {
        Log.e(TAG, "Missing required parameter: " + param);
        return false;
      }
    }
    return true;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.d(TAG, "Method call: " + call.method);
    
    try {
      switch (call.method) {
        case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;

        case "printText":
          handlePrintText(result);
          break;
          
        case "getStatus":
          handleGetStatus(result);
          break;
          
        case "setupPage":
          handleSetupPage(call, result);
          break;
          
        case "clearPage":
          handleClearPage(result);
          break;
          
        case "printPage":
          handlePrintPage(call, result);
          break;
          
        case "drawText":
          handleDrawText(call, result);
          break;
          
        case "drawTextEx":
          handleDrawTextEx(call, result);
          break;
          
        case "drawLine":
          handleDrawLine(call, result);
          break;
          
        case "drawBarcode":
          handleDrawBarcode(call, result);
          break;
          
        case "drawBitmap":
          handleDrawBitmap(call, result);
          break;
          
        case "drawBitmapEx":
          handleDrawBitmapEx(call, result);
          break;
          
        case "setGrayLevel":
          handleSetGrayLevel(call, result);
          break;
          
        case "setSpeedLevel":
          handleSetSpeedLevel(call, result);
          break;
          
        case "paperFeed":
          handlePaperFeed(call, result);
          break;
          
        case "dispose":
          handleDispose(result);
          break;
          
        // Legacy prn_ methods for backward compatibility
        case "prnOpen":
          handlePrnOpen(result);
          break;
          
        case "prnClose":
          handlePrnClose(result);
          break;
          
        case "prnGetStatus":
          handlePrnGetStatus(result);
          break;
          
        case "prnSetupPage":
          handlePrnSetupPage(call, result);
          break;
          
        case "prnClearPage":
          handlePrnClearPage(result);
          break;
          
        case "prnPrintPage":
          handlePrnPrintPage(call, result);
          break;
          
        case "prnDrawText":
          handlePrnDrawText(call, result);
          break;
          
        case "prnDrawTextEx":
          handlePrnDrawTextEx(call, result);
          break;
          
        case "prnDrawLine":
          handlePrnDrawLine(call, result);
          break;
          
        case "prnDrawBarcode":
          handlePrnDrawBarcode(call, result);
          break;
          
        case "prnDrawBitmap":
          handlePrnDrawBitmap(call, result);
          break;
          
        case "prnSetBlack":
          handlePrnSetBlack(call, result);
          break;
          
        case "prnSetSpeed":
          handlePrnSetSpeed(call, result);
          break;
          
        case "prnPaperForWard":
          handlePrnPaperForWard(call, result);
          break;
          
        case "prnPaperBack":
          handlePrnPaperBack(call, result);
          break;
          
        case "prnGetTemp":
          handlePrnGetTemp(result);
          break;
          
        case "getTemp":
          handleGetTemp(result);
          break;
          
        case "printCachedPage":
          handlePrintCachedPage(result);
          break;
          
        default:
          result.notImplemented();
          break;
      }
    } catch (Exception e) {
      Log.e(TAG, "Error in method call: " + call.method, e);
      result.error("PRINTER_ERROR", e.getMessage(), Log.getStackTraceString(e));
    }
  }

  // Handler methods for each operation

  /** Diagnostic: prints a short test line, replies with the PRNSTS_* code. */
  private void handlePrintText(Result result) {
    commitAsync(result, new PrintOp() {
      @Override
      public int run(PrinterManager pm) {
        pm.setupPage(3, -1);
        pm.drawLine(2, 2, 2, 3, 3);
        return pm.printPage(0);
      }
    });
  }
  private void handleGetStatus(Result result) {
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int status = printer.getStatus();
      result.success(status);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleSetupPage(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "height", "width")) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int height = (int) arguments.get("height");
    int width = (int) arguments.get("width");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int setupResult = printer.setupPage(height, width);
      result.success(setupResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleClearPage(Result result) {
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int clearResult = printer.clearPage();
      result.success(clearResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handlePrintPage(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "rotate")) {
      result.error("INVALID_ARGUMENTS", "Missing rotate parameter", null);
      return;
    }

    Map<String, Object> arguments = call.arguments();
    final int rotate = (int) arguments.get("rotate");
    commitAsync(result, new PrintOp() {
      @Override
      public int run(PrinterManager pm) {
        return pm.printPage(rotate);
      }
    });
  }

  private void handleDrawText(MethodCall call, Result result) {
    String[] requiredParams = {"data", "x", "y", "fontName", "fontSize", "isBold", "isItalic", "rotate"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    String data = (String) arguments.get("data");
    int x = (int) arguments.get("x");
    int y = (int) arguments.get("y");
    String fontName = (String) arguments.get("fontName");
    int fontSize = (int) arguments.get("fontSize");
    boolean isBold = (boolean) arguments.get("isBold");
    boolean isItalic = (boolean) arguments.get("isItalic");
    int rotate = (int) arguments.get("rotate");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int drawResult = printer.drawText(data, x, y, fontName, fontSize, isBold, isItalic, rotate);
      result.success(drawResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDrawTextEx(MethodCall call, Result result) {
    String[] requiredParams = {"data", "x", "y", "width", "height", "fontName", "fontSize", "isBold", "isItalic", "rotate", "style", "format"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    String data = (String) arguments.get("data");
    int x = (int) arguments.get("x");
    int y = (int) arguments.get("y");
    int width = (int) arguments.get("width");
    int height = (int) arguments.get("height");
    String fontName = (String) arguments.get("fontName");
    int fontSize = (int) arguments.get("fontSize");
    boolean isBold = (boolean) arguments.get("isBold");
    boolean isItalic = (boolean) arguments.get("isItalic");
    int rotate = (int) arguments.get("rotate");
    int style = (int) arguments.get("style");
    int format = (int) arguments.get("format");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int drawResult = printer.drawTextEx(data, x, y, width, height, fontName, fontSize, rotate, style, format);
      result.success(drawResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDrawLine(MethodCall call, Result result) {
    String[] requiredParams = {"x0", "y0", "x1", "y1", "lineWidth"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int x0 = (int) arguments.get("x0");
    int y0 = (int) arguments.get("y0");
    int x1 = (int) arguments.get("x1");
    int y1 = (int) arguments.get("y1");
    int lineWidth = (int) arguments.get("lineWidth");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int drawResult = printer.drawLine(x0, y0, x1, y1, lineWidth);
      result.success(drawResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDrawBarcode(MethodCall call, Result result) {
    String[] requiredParams = {"data", "x", "y", "barcodeType", "width", "height", "rotate"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    String data = (String) arguments.get("data");
    int x = (int) arguments.get("x");
    int y = (int) arguments.get("y");
    int barcodeType = (int) arguments.get("barcodeType");
    int width = (int) arguments.get("width");
    int height = (int) arguments.get("height");
    int rotate = (int) arguments.get("rotate");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      int drawResult = printer.drawBarcode(data, x, y, barcodeType, width, height, rotate);
      result.success(drawResult);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDrawBitmap(MethodCall call, Result result) {
    String[] requiredParams = {"image", "xDest", "yDest"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    String imagePath = (String) arguments.get("image");
    int xDest = (int) arguments.get("xDest");
    int yDest = (int) arguments.get("yDest");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      try {
        File imageFile = new File(imagePath);
        if (!imageFile.exists()) {
          result.error("FILE_NOT_FOUND", "Image file not found: " + imagePath, null);
          return;
        }
        
        Bitmap bitmap = BitmapFactory.decodeFile(imagePath);
        if (bitmap == null) {
          result.error("INVALID_IMAGE", "Failed to decode image: " + imagePath, null);
          return;
        }
        
        int drawResult = printer.drawBitmap(bitmap, xDest, yDest);
        result.success(drawResult);
      } catch (Exception e) {
        Log.e(TAG, "Error drawing bitmap", e);
        result.error("BITMAP_ERROR", e.getMessage(), Log.getStackTraceString(e));
      }
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDrawBitmapEx(MethodCall call, Result result) {
    String[] requiredParams = {"bytes", "xDest", "yDest", "widthDest", "heightDest"};
    if (!validateParameters(call.arguments(), requiredParams)) {
      result.error("INVALID_ARGUMENTS", "Missing required parameters", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    ArrayList<Integer> bytesList = (ArrayList<Integer>) arguments.get("bytes");
    int xDest = (int) arguments.get("xDest");
    int yDest = (int) arguments.get("yDest");
    int widthDest = (int) arguments.get("widthDest");
    int heightDest = (int) arguments.get("heightDest");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      try {
        // Convert ArrayList<Integer> to byte array
        byte[] bytes = new byte[bytesList.size()];
        for (int i = 0; i < bytesList.size(); i++) {
          bytes[i] = bytesList.get(i).byteValue();
        }
        
        int drawResult = printer.drawBitmapEx(bytes, xDest, yDest, widthDest, heightDest);
        result.success(drawResult);
      } catch (Exception e) {
        Log.e(TAG, "Error drawing bitmap ex", e);
        result.error("BITMAP_ERROR", e.getMessage(), Log.getStackTraceString(e));
      }
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleSetGrayLevel(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "level")) {
      result.error("INVALID_ARGUMENTS", "Missing level parameter", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int level = (int) arguments.get("level");
    
    // Validate gray level range
    if (level < MIN_PRINTER_HUE_VALUE || level > MAX_PRINTER_HUE_VALUE) {
      result.error("INVALID_RANGE", "Gray level must be between " + MIN_PRINTER_HUE_VALUE + " and " + MAX_PRINTER_HUE_VALUE, null);
      return;
    }
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      printer.setGrayLevel(level);
      result.success(0);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleSetSpeedLevel(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "level")) {
      result.error("INVALID_ARGUMENTS", "Missing level parameter", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int level = (int) arguments.get("level");
    
    // Validate speed level range
    if (level < MIN_PRINTER_SPEED_VALUE || level > MAX_PRINTER_SPEED_VALUE) {
      result.error("INVALID_RANGE", "Speed level must be between " + MIN_PRINTER_SPEED_VALUE + " and " + MAX_PRINTER_SPEED_VALUE, null);
      return;
    }
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      printer.setSpeedLevel(level);
      result.success(0);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handlePaperFeed(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "length")) {
      result.error("INVALID_ARGUMENTS", "Missing length parameter", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int length = (int) arguments.get("length");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      printer.paperFeed(length);
      result.success(0);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleDispose(Result result) {
    if (mPrinterManager != null) {
      try {
        int closeResult = mPrinterManager.close();
        mPrinterManager = null;
        isPrinterInitialized = false;
        result.success(closeResult);
        Log.d(TAG, "PrinterManager disposed");
      } catch (Exception e) {
        Log.e(TAG, "Error disposing PrinterManager", e);
        result.error("DISPOSE_ERROR", e.getMessage(), Log.getStackTraceString(e));
      }
    } else {
      result.success(0);
    }
  }

  // Legacy prn_ methods - these are wrappers around the main methods for backward compatibility
  private void handlePrnOpen(Result result) {
    PrinterManager printer = getPrinterManager();
    if (printer != null && isPrinterInitialized) {
      result.success(0);
    } else {
      result.error("PRINTER_ERROR", "Failed to open printer", null);
    }
  }

  private void handlePrnClose(Result result) {
    handleDispose(result);
  }

  private void handlePrnGetStatus(Result result) {
    handleGetStatus(result);
  }

  private void handlePrnSetupPage(MethodCall call, Result result) {
    handleSetupPage(call, result);
  }

  private void handlePrnClearPage(Result result) {
    handleClearPage(result);
  }

  private void handlePrnPrintPage(MethodCall call, Result result) {
    handlePrintPage(call, result);
  }

  private void handlePrnDrawText(MethodCall call, Result result) {
    handleDrawText(call, result);
  }

  private void handlePrnDrawTextEx(MethodCall call, Result result) {
    handleDrawTextEx(call, result);
  }

  private void handlePrnDrawLine(MethodCall call, Result result) {
    handleDrawLine(call, result);
  }

  private void handlePrnDrawBarcode(MethodCall call, Result result) {
    handleDrawBarcode(call, result);
  }

  private void handlePrnDrawBitmap(MethodCall call, Result result) {
    handleDrawBitmap(call, result);
  }

  private void handlePrnSetBlack(MethodCall call, Result result) {
    handleSetGrayLevel(call, result);
  }

  private void handlePrnSetSpeed(MethodCall call, Result result) {
    handleSetSpeedLevel(call, result);
  }

  private void handlePrnPaperForWard(MethodCall call, Result result) {
    handlePaperFeed(call, result);
  }

  private void handlePrnPaperBack(MethodCall call, Result result) {
    if (!validateParameters(call.arguments(), "length")) {
      result.error("INVALID_ARGUMENTS", "Missing length parameter", null);
      return;
    }
    
    Map<String, Object> arguments = call.arguments();
    int length = (int) arguments.get("length");
    
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      printer.prn_paperBack(length);
      result.success(0);
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handlePrnGetTemp(Result result) {
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      result.success(printer.prn_getTemp());
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handleGetTemp(Result result) {
    PrinterManager printer = getPrinterManager();
    if (printer != null) {
      result.success(printer.getTemp());
    } else {
      result.error("PRINTER_ERROR", "Printer not initialized", null);
    }
  }

  private void handlePrintCachedPage(Result result) {
    commitAsync(result, new PrintOp() {
      @Override
      public int run(PrinterManager pm) {
        return pm.printCachedPage();
      }
    });
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    if (printThread != null) {
      printThread.quitSafely();
      printThread = null;
    }
    if (mPrinterManager != null) {
      try {
        mPrinterManager.close();
      } catch (Exception e) {
        Log.e(TAG, "Error closing PrinterManager on detach", e);
      }
      mPrinterManager = null;
      isPrinterInitialized = false;
    }
    Log.d(TAG, "PosPrinterPlugin detached from engine");
  }
}


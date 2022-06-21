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
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.Spinner;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;

/** PosPrinterPlugin */
public class PosPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private PrinterManager mPrinterManager;

  private PrinterManager getPrinterManager() {
    if (mPrinterManager == null) {
      mPrinterManager = new PrinterManager();
      mPrinterManager.open();
    }
    return mPrinterManager;
  }
  //Printer gray value 0-4
  private final static int DEF_PRINTER_HUE_VALUE = 0;
  private final static int MIN_PRINTER_HUE_VALUE = 0;
  private final static int MAX_PRINTER_HUE_VALUE = 4;

  //Print speed value 0-9
  private final static int DEF_PRINTER_SPEED_VALUE = 9;
  private final static int MIN_PRINTER_SPEED_VALUE = 0;
  private final static int MAX_PRINTER_SPEED_VALUE = 9;

  // Printer status
  private final static int PRNSTS_OK = 0;                //OK
  private final static int PRNSTS_OUT_OF_PAPER = -1;    //Out of paper
  private final static int PRNSTS_OVER_HEAT = -2;        //Over heat
  private final static int PRNSTS_UNDER_VOLTAGE = -3;    //under voltage
  private final static int PRNSTS_BUSY = -4;            //Device is busy
  private final static int PRNSTS_ERR = -256;            //Common error
  private final static int PRNSTS_ERR_DRIVER = -257;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "pos_printer");
    channel.setMethodCallHandler(this);

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }else if(call.method.equals("printText")){
//      testing out things
      int ret = getPrinterManager().getStatus();
      System.out.println("Printer status");
      System.out.println(ret);
      if(ret == PRNSTS_OK){
        getPrinterManager().setupPage(384,-1);



        int fontSize = 24;
        int fontStyle= 0x0000;
        String fontName = "simsun";



        int height = 0;

        mPrinterManager.drawText("Prince!!", 5,5," l",5,true,false, 100);

      }




      result.success("Print testing");
    }else if(call.method.equals("getStatus")){
      try{
        //      get printers status
        int ret = getPrinterManager().getStatus();
        result.success(ret);


      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("setupPage")){
//      print page setup
      try {
        HashMap arguments = (HashMap) call.arguments;
        int height =(int) arguments.get("height");
        int width = (int) arguments.get("width");
        int setup = getPrinterManager().setupPage(height,width);
        result.success(setup);
      } catch (Exception ex) {
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }


    }else if(call.method.equals("dispose")){

      try{

//     close printer instance
        result.success(mPrinterManager.close());
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    }else if(call.method.equals("setGrayLevel")){
      try{

//     set gray level of printer
        ArrayList arguments = (ArrayList) call.arguments;
        int level = (int) arguments.get(0);
        getPrinterManager().setGrayLevel(level);
        result.success(0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }

    }else if(call.method.equals("paperFeed")){
      try{

//     set paper feed length of printer
        ArrayList arguments = (ArrayList) call.arguments;
        int length = (int) arguments.get(0);
        getPrinterManager().paperFeed(length);
        result.success(0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("setSpeedLevel")){
      try{

//     set speed level of printer
        ArrayList arguments = (ArrayList) call.arguments;
        int speedLevel = (int) arguments.get(0);
        getPrinterManager().setSpeedLevel(speedLevel);
        result.success(0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("clearPage")){
      try{

//     clear printer page

       int page =  getPrinterManager().clearPage();
        result.success(page);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("printPage")){
      try{

//     print page
        ArrayList arguments = (ArrayList) call.arguments;
        int rotate = (int) arguments.get(0);

        result.success( getPrinterManager().printPage(rotate));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawLine")){
      try{

//     drawline
        HashMap arguments = (HashMap) call.arguments;
        int x0 = (int) arguments.get("x0");
        int y0 = (int) arguments.get("y0");
        int x1 = (int) arguments.get("x1");
        int y1 = (int) arguments.get("y1");
        int lineWidth = (int) arguments.get("lineWidth");

        result.success( getPrinterManager().drawLine(x0,y0,x1,y1,lineWidth));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawText")){
      try{

//     drawText
        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        String fontName = (String) arguments.get("fontName");
        int fontSize = (int) arguments.get("fontSize");
        boolean bold = (boolean) arguments.get("isBold");
        boolean italic = (boolean) arguments.get("isItalic");
        int rotate = (int) arguments.get("rotate");

        result.success( getPrinterManager().drawText(data,x,y,fontName,fontSize,bold,italic,rotate));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawTextEx")){
      try{

//     drawTextEx
        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        int width = (int) arguments.get("width");
        int height = (int) arguments.get("height");

        String fontName = (String) arguments.get("fontName");
        int fontSize = (int) arguments.get("fontSize");
        boolean bold = (boolean) arguments.get("isBold");
        boolean italic = (boolean) arguments.get("isItalic");
        int rotate = (int) arguments.get("rotate");
        int style = (int) arguments.get("style");
        int format = (int) arguments.get("format");


        result.success( getPrinterManager().drawTextEx(data, x,y,width,height,fontName,fontSize,rotate,style,format));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawBarcode")){
      try{

//     drawBarcode
        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        int barcodetype = (int) arguments.get("barcodetype");
        int width = (int) arguments.get("width");
        int height = (int) arguments.get("height");
        int rotate = (int) arguments.get("rotate");

        result.success( getPrinterManager().drawBarcode(data, x,y,barcodetype,width,height,rotate));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawBitmap")){
      try{

//     drawBitmap
        HashMap arguments = (HashMap) call.arguments;
        Bitmap bitmap = (Bitmap) arguments.get("bitmap");
        int xDest = (int) arguments.get("xDest");
        int yDest = (int) arguments.get("yDest");


        result.success( getPrinterManager().drawBitmap(bitmap, xDest,yDest));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("drawBitmapEx")){
      try{

//     drawBitmapEx
        HashMap arguments = (HashMap) call.arguments;
        byte[] pbmp = (byte[]) arguments.get("byte");
        int xDest = (int) arguments.get("xDest");
        int yDest = (int) arguments.get("yDest");
        int widthDest = (int) arguments.get("widthDest");
        int heightDest = (int) arguments.get("heightDest");


        result.success( getPrinterManager().drawBitmapEx(pbmp, xDest,yDest,widthDest,heightDest));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_open")){
      try{

//     prn_open
          result.success( getPrinterManager().prn_open());
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_close")){
      try{

//     prn_close
getPrinterManager().prn_close();
        result.success( 0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_setBlack")){
      try{
        ArrayList arguments = (ArrayList) call.arguments;
        int level = (int) arguments.get(0);
//     prn_setBlack
        result.success( getPrinterManager().prn_setBlack(level));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_paperForWard")){
      try{
        ArrayList arguments = (ArrayList) call.arguments;
        int length = (int) arguments.get(0);
//     prn_paperForWard
      getPrinterManager().prn_paperForWard(length);
        result.success( 0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_paperBack")){
      try{
        ArrayList arguments = (ArrayList) call.arguments;
        int length = (int) arguments.get(0);
//     prn_paperBack
      getPrinterManager().prn_paperBack(length);
        result.success(0);
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_setSpeed")){
      try{
        ArrayList arguments = (ArrayList) call.arguments;
        int level = (int) arguments.get(0);
//     prn_setSpeed
        result.success( getPrinterManager().prn_setSpeed(level));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_getTemp")){
      try{

//     prn_getTemp
        result.success( getPrinterManager().prn_getTemp());
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_setupPage")){
      try{
        HashMap arguments = (HashMap) call.arguments;
        int width = (int) arguments.get("width");
        int height = (int) arguments.get("height");
//     prn_setupPage
        result.success( getPrinterManager().prn_setupPage(width,height));
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_clearPage")){
      try{

//     prn_clearPage
        result.success( getPrinterManager().prn_clearPage());
      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_printPage")){
      try{

//     prn_printPage

        ArrayList arguments = (ArrayList) call.arguments;
        int rotate = (int) arguments.get(0);
        result.success( getPrinterManager().prn_printPage(rotate));

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_drawLine")){
      try{

//     prn_drawLine

        HashMap arguments = (HashMap) call.arguments;
        int x0 = (int) arguments.get("x0");
        int y0 = (int) arguments.get("y0");
        int x1 = (int) arguments.get("x1");
        int y1 = (int) arguments.get("y1");
        int lineWidth = (int) arguments.get("lineWidth");
        result.success( getPrinterManager().prn_drawLine(x0,y0,x1,y1,lineWidth));


      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_drawText")){
      try{

//     prn_drawText

        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        String fontName = (String) arguments.get("fontName");
        int fontSize = (int) arguments.get("fontSize");
        boolean bold = (boolean) arguments.get("isBold");
        boolean italic = (boolean) arguments.get("isItalic");
        int rotate = (int) arguments.get("rotate");
        result.success( getPrinterManager().prn_drawText(data, x, y,fontName,fontSize,bold, italic,rotate));


      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_drawTextEx")){
      try{

//     prn_drawTextEx
        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        int width = (int) arguments.get("width");
        int height = (int) arguments.get("height");
        String fontName = (String) arguments.get("fontName");
        int fontSize = (int) arguments.get("fontSize");
        boolean bold = (boolean) arguments.get("isBold");
        boolean italic = (boolean) arguments.get("isItalic");
        int rotate = (int) arguments.get("rotate");
        int style = (int) arguments.get("style");
        int format = (int) arguments.get("format");


        result.success( getPrinterManager().prn_drawTextEx(data, x,y,width,height,fontName,fontSize,rotate,style,format));

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_drawBarcode")){
      try{

//     prn_drawBarcode
        HashMap arguments = (HashMap) call.arguments;
        String data = (String) arguments.get("data");
        int x = (int) arguments.get("x");
        int y = (int) arguments.get("y");
        int barcodetype = (int) arguments.get("barcodetype");
        int width = (int) arguments.get("width");
        int height = (int) arguments.get("height");
        int rotate = (int) arguments.get("rotate");

        result.success( getPrinterManager().prn_drawBarcode(data, x,y,barcodetype,width,height,rotate));

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_drawBitmap")){
      try{

//     prn_drawBitmap
        HashMap arguments = (HashMap) call.arguments;
        Bitmap bitmap = (Bitmap) arguments.get("bitmap");
        int xDest = (int) arguments.get("xDest");
        int yDest = (int) arguments.get("yDest");


        result.success( getPrinterManager().prn_drawBitmap(bitmap, xDest,yDest));

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("prn_getStatus")){
      try{

//     prn_getStatus

        result.success( getPrinterManager().prn_getStatus());

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("getTemp")){
      try{

//     getTemp

        result.success( getPrinterManager().getTemp());

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }else if(call.method.equals("printCachedPage")){
      try{

//     printCachedPage

        result.success( getPrinterManager().printCachedPage());

      }catch (Exception ex){
        result.error("1", ex.getMessage(), ex.getStackTrace());
      }
    }



//    * end
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}


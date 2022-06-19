import 'package:bitmap/bitmap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pos_printer_platform_interface.dart';

/// An implementation of [PosPrinterPlatform] that uses method channels.
class MethodChannelPosPrinter extends PosPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pos_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> print() async {
    final print = await methodChannel.invokeMethod<String>('printText');
    return print;
  }

  @override
  Future<int?> getStatus() async {
    final status = await methodChannel.invokeMethod<int>('getStatus');
    return status;
  }

  @override
  Future<int?> dispose() async {
    final dispose = await methodChannel.invokeMethod<int>('dispose');
    return dispose;
  }

  @override
  Future<int?> setupPage({required int height, required int width}) async {
    final setup = await methodChannel.invokeMethod<int>('setupPage', {
      'height': height,
      'width': width,
    });
    return setup;
  }

  //* sets gray level
  @override
  Future<int?> setGrayLevel(int level) async {
    final setLevel = await methodChannel.invokeMethod("setGrayLevel", [level]);
    return setLevel;
  }

  //* sets paper feed
  @override
  Future<int?> paperFeed(int length) async {
    final length = await methodChannel.invokeMethod('paperFeed');
    return length;
  }

//* set speed level [0-9]
  @override
  Future<int?> setSpeedLevel(int level) async {
    final level = await methodChannel.invokeMethod('setSpeedLevel');
    return level;
  }

  // * clears page setup
  @override
  Future<int?> clearPage() async {
    return await methodChannel.invokeMethod('clearPage');
  }

  //* print page
  @override
  Future<int?> printPage(int rotate) async {
    return await methodChannel.invokeMethod('printPage', [rotate]);
  }

  //* draw
  @override
  Future<int?> drawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) async {
    return await methodChannel.invokeMethod('drawLine', {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'lineWidth': lineWidth,
    });
  }

  //* draw text
  @override
  Future<int?> drawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) async {
    return await methodChannel.invokeMethod('drawText', {
      'data': data,
      'x': x,
      'y': y,
      'fontName': fontName,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
    });
  }

  //* draw text extended
  @override
  Future<int?> drawTextEx(
      {required String data,
      required int x,
      required int y,
      required int width,
      required int height,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate,
      required int style,
      required int format}) async {
    return await methodChannel.invokeMethod('drawTextEx', {
      'data': data,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'fontName': fontName,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
      'style': style,
      'format': format,
    });
  }

  //* draw barcode
  @override
  Future<int?> drawBarcode({
    required String data,
    required int x,
    required int y,
    required int barcodeType,
    required int width,
    required int height,
    required int rotate,
  }) async {
    return await methodChannel.invokeMethod('drawBarcode', {
      'data': data,
      'x': x,
      'y': y,
      'barcodeType': barcodeType,
      'width': width,
      'height': height,
      'rotate': rotate,
    });
  }

  // * draw bitmap
  @override
  Future<int?> drawBitmap({
    required Bitmap bitmap,
    required int xDest,
    required int yDest,
  }) async {
    return await methodChannel.invokeMethod('drawBitmap', {
      'bitmap': bitmap,
      'xDest': xDest,
      'yDest': yDest,
    });
  }

  // * draw bitmap ex
  @override
  Future<int?> drawBitmapEx({
    required List<int> bytes,
    required int xDest,
    required int yDest,
    required int widthDest,
    required int heightDest,
  }) async {
    return await methodChannel.invokeMethod('drawBitmapEx', {
      'bytes': bytes,
      'xDest': xDest,
      'yDest': yDest,
      'widthDest': widthDest,
      'heightDest': heightDest,
    });
  }

  // * printer open
  @override
  Future<int?> prnOpen() async {
    return await methodChannel.invokeMethod('prn_open');
  }

  // * printer close
  @override
  Future<int?> prnClose() async {
    return await methodChannel.invokeMethod('prn_close');
  }

  // * printer set black
  @override
  Future<int?> prnSetBlack(int level) async {
    return await methodChannel.invokeMethod('prn_setBlack', [level]);
  }

  // * print paper forward
  @override
  Future<int?> prnPaperForWard(int length) async {
    return await methodChannel.invokeMethod('prn_paperForWard', [length]);
  }

  // * print paper back
  @override
  Future<int?> prnPaperBack(int length) async {
    return await methodChannel.invokeMethod('prn_paperBack', [length]);
  }

  // * printer set speed [0-9]
  @override
  Future<int?> prnSetSpeed(int level) async {
    return await methodChannel.invokeMethod('prn_setSpeed', [level]);
  }

  // * get printer temperature
  @override
  Future<int?> prnGetTemp() async {
    return await methodChannel.invokeMethod('prn_getTemp');
  }

  // * set up page
  @override
  Future<int?> prnSetupPage({required int width, required int height}) {
    return methodChannel.invokeMethod('prn_setupPage', {
      'width': width,
      'height': height,
    });
  }

  //* clear page setup
  @override
  Future<int?> prnClearPage() async {
    return await methodChannel.invokeMethod('prn_clearPage');
  }

  // * print page
  @override
  Future<int?> prnPrintPage(int rotate) async {
    return await methodChannel.invokeMethod('prn_printPage', [rotate]);
  }

  // * draw line
  @override
  Future<int?> prnDrawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) async {
    return await methodChannel.invokeMethod('prn_drawLine', {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'lineWidth': lineWidth,
    });
  }

  //* draw text
  @override
  Future<int?> prnDrawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) async {
    return await methodChannel.invokeMethod('prn_drawText', {
      'data': data,
      'x': x,
      'y': y,
      'fontName': fontName,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
    });
  }

  // * draw text extended
  @override
  Future<int?> prnDrawTextEx(
      {required String data,
      required int x,
      required int y,
      required int width,
      required int height,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate,
      required int style,
      required int format}) async {
    return await methodChannel.invokeMethod('prn_drawTextEx', {
      'data': data,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'fontName': fontName,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
      'style': style,
      'format': format,
    });
  }

  // * prn_drawBarcode
  @override
  Future<int?> prnDrawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) async {
    return await methodChannel.invokeMethod('prn_drawBarcode', {
      'data': data,
      'x': x,
      'y': y,
      'barcodeType': barcodeType,
      'width': width,
      'height': height,
      'rotate': rotate,
    });
  }

  /// prn_drawBarcode
  @override
  Future<int?> prnDrawBitmap({
    required Bitmap bitmap,
    required int xDest,
    required int yDest,
  }) async {
    return await methodChannel.invokeMethod('prn_drawBitmap', {
      'bitmap': bitmap,
      'xDest': xDest,
      'yDest': yDest,
    });
  }

  //* prn_getStatus
  @override
  Future<int?> prnGetStatus() async {
    return await methodChannel.invokeMethod('prn_getStatus');
  }

  // * get temperature
  @override
  Future<int?> getTemp() async {
    return await methodChannel.invokeMethod('getTemp');
  }

  //* printCachedPage
  @override
  Future<int?> printCachedPage() async {
    return await methodChannel.invokeMethod('printCachedPage');
  }
}

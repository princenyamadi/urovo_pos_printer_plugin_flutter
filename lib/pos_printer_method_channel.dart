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

  @override
  Future<int?> setGrayLevel(int level) async {
    final setLevel = await methodChannel.invokeMethod<int>("setGrayLevel", {
      'level': level,
    });
    return setLevel;
  }

  @override
  Future<int?> paperFeed(int length) async {
    final result = await methodChannel.invokeMethod<int>('paperFeed', {
      'length': length,
    });
    return result;
  }

  @override
  Future<int?> setSpeedLevel(int level) async {
    final result = await methodChannel.invokeMethod<int>('setSpeedLevel', {
      'level': level,
    });
    return result;
  }

  @override
  Future<int?> clearPage() async {
    return await methodChannel.invokeMethod('clearPage');
  }

  @override
  Future<int?> printPage(int rotate) async {
    return await methodChannel.invokeMethod('printPage', {
      'rotate': rotate,
    });
  }

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

  @override
  Future<int?> drawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate}) async {
    return await methodChannel.invokeMethod('drawText', {
      'data': data,
      'x': x,
      'y': y,
      'fontName': fontName,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
    });
  }

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

  @override
  Future<int?> drawBitmap({
    required String image,
    required int xDest,
    required int yDest,
  }) async {
    return await methodChannel.invokeMethod('drawBitmap', {
      'image': image,
      'xDest': xDest,
      'yDest': yDest,
    });
  }

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

  // Legacy prn_ methods for backward compatibility
  @override
  Future<int?> prnOpen() async {
    return await methodChannel.invokeMethod('prnOpen');
  }

  @override
  Future<int?> prnClose() async {
    return await methodChannel.invokeMethod('prnClose');
  }

  @override
  Future<int?> prnSetBlack(int level) async {
    return await methodChannel.invokeMethod('prnSetBlack', {
      'level': level,
    });
  }

  @override
  Future<int?> prnPaperForWard(int length) async {
    return await methodChannel.invokeMethod('prnPaperForWard', {
      'length': length,
    });
  }

  @override
  Future<int?> prnPaperBack(int length) async {
    return await methodChannel.invokeMethod('prnPaperBack', {
      'length': length,
    });
  }

  @override
  Future<int?> prnSetSpeed(int level) async {
    return await methodChannel.invokeMethod('prnSetSpeed', {
      'level': level,
    });
  }

  @override
  Future<int?> prnGetTemp() async {
    return await methodChannel.invokeMethod('prnGetTemp');
  }

  @override
  Future<int?> prnSetupPage({required int width, required int height}) async {
    return methodChannel.invokeMethod('prnSetupPage', {
      'width': width,
      'height': height,
    });
  }

  @override
  Future<int?> prnClearPage() async {
    return await methodChannel.invokeMethod('prnClearPage');
  }

  @override
  Future<int?> prnPrintPage(int rotate) async {
    return await methodChannel.invokeMethod('prnPrintPage', {
      'rotate': rotate,
    });
  }

  @override
  Future<int?> prnDrawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) async {
    return await methodChannel.invokeMethod('prnDrawLine', {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'lineWidth': lineWidth,
    });
  }

  @override
  Future<int?> prnDrawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate}) async {
    return await methodChannel.invokeMethod('prnDrawText', {
      'data': data,
      'x': x,
      'y': y,
      'fontName': fontName,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'rotate': rotate,
    });
  }

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
    return await methodChannel.invokeMethod('prnDrawTextEx', {
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

  @override
  Future<int?> prnDrawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) async {
    return await methodChannel.invokeMethod('prnDrawBarcode', {
      'data': data,
      'x': x,
      'y': y,
      'barcodeType': barcodeType,
      'width': width,
      'height': height,
      'rotate': rotate,
    });
  }

  @override
  Future<int?> prnDrawBitmap({
    required String image,
    required int xDest,
    required int yDest,
  }) async {
    return await methodChannel.invokeMethod('prnDrawBitmap', {
      'image': image,
      'xDest': xDest,
      'yDest': yDest,
    });
  }

  @override
  Future<int?> prnGetStatus() async {
    return await methodChannel.invokeMethod('prnGetStatus');
  }

  @override
  Future<int?> getTemp() async {
    return await methodChannel.invokeMethod('getTemp');
  }

  @override
  Future<int?> printCachedPage() async {
    return await methodChannel.invokeMethod('printCachedPage');
  }
}

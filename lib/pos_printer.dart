import 'package:bitmap/bitmap.dart';

import 'pos_printer_platform_interface.dart';

class PosPrinter {
  Future<String?> getPlatformVersion() {
    return PosPrinterPlatform.instance.getPlatformVersion();
  }

  Future<String?> print() {
    return PosPrinterPlatform.instance.print();
  }

  Future<int?> getStatus() {
    return PosPrinterPlatform.instance.getStatus();
  }

  Future<int?> dispose() {
    return PosPrinterPlatform.instance.dispose();
  }

  Future<int?> setupPage({required int height, required int width}) {
    return PosPrinterPlatform.instance.setupPage(height: height, width: width);
  }

  Future<int?> setGrayLevel(int level) {
    return PosPrinterPlatform.instance.setGrayLevel(level);
  }

  Future<int?> paperFeed(int length) {
    return PosPrinterPlatform.instance.paperFeed(length);
  }

  Future<int?> setSpeedLevel(int level) {
    return PosPrinterPlatform.instance.setSpeedLevel(level);
  }

  Future<int?> clearPage() {
    return PosPrinterPlatform.instance.clearPage();
  }

  Future<int?> printPage(int rotate) {
    return PosPrinterPlatform.instance.printPage(rotate);
  }

  Future<int?> drawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    return PosPrinterPlatform.instance.drawLine(
      x0: x0,
      y0: y0,
      x1: x1,
      y1: y1,
      lineWidth: lineWidth,
    );
  }

  Future<int?> drawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    return PosPrinterPlatform.instance.drawText(
      data: data,
      x: x,
      y: y,
      fontName: fontName,
      isBold: isBold,
      isItalic: isItalic,
      rotate: rotate,
    );
  }

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
      required int format}) {
    return PosPrinterPlatform.instance.drawTextEx(
      data: data,
      x: x,
      y: y,
      width: width,
      height: height,
      fontName: fontName,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
      rotate: rotate,
      style: style,
      format: format,
    );
  }

  Future<int?> drawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    return PosPrinterPlatform.instance.drawBarcode(
      data: data,
      x: x,
      y: y,
      barcodeType: barcodeType,
      width: width,
      height: height,
      rotate: rotate,
    );
  }

  Future<int?> drawBitmap(
      {required Bitmap bitmap, required int xDest, required int yDest}) {
    return PosPrinterPlatform.instance.drawBitmap(
      bitmap: bitmap,
      xDest: xDest,
      yDest: yDest,
    );
  }

  Future<int?> drawBitmapEx(
      {required List<int> bytes,
      required int xDest,
      required int yDest,
      required int widthDest,
      required int heightDest}) {
    return PosPrinterPlatform.instance.drawBitmapEx(
      bytes: bytes,
      xDest: xDest,
      yDest: yDest,
      widthDest: widthDest,
      heightDest: heightDest,
    );
  }

  Future<int?> prnOpen() {
    return PosPrinterPlatform.instance.prnOpen();
  }

  Future<int?> prnClose() {
    return PosPrinterPlatform.instance.prnClose();
  }

  Future<int?> prnSetBlack(int level) {
    return PosPrinterPlatform.instance.prnSetBlack(level);
  }

  Future<int?> prnPaperForWard(int length) {
    return PosPrinterPlatform.instance.prnPaperForWard(length);
  }

  Future<int?> prnSetSpeed(int level) {
    return PosPrinterPlatform.instance.prnSetSpeed(level);
  }

  Future<int?> prnGetTemp() {
    return PosPrinterPlatform.instance.prnGetTemp();
  }

  Future<int?> prnGetStatus() {
    return PosPrinterPlatform.instance.prnGetStatus();
  }

  Future<int?> prnSetupPage({required int width, required int height}) {
    return PosPrinterPlatform.instance
        .prnSetupPage(width: width, height: height);
  }

  Future<int?> prnClearPage() {
    return PosPrinterPlatform.instance.prnClearPage();
  }

  Future<int?> prnPrintPage(int rotate) {
    return PosPrinterPlatform.instance.prnPrintPage(rotate);
  }

  Future<int?> prnDrawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    return PosPrinterPlatform.instance.prnDrawLine(
      x0: x0,
      y0: y0,
      x1: x1,
      y1: y1,
      lineWidth: lineWidth,
    );
  }

  Future<int?> prnDrawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    return PosPrinterPlatform.instance.prnDrawText(
      data: data,
      x: x,
      y: y,
      fontName: fontName,
      isBold: isBold,
      isItalic: isItalic,
      rotate: rotate,
    );
  }

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
      required int format}) {
    return PosPrinterPlatform.instance.prnDrawTextEx(
      data: data,
      x: x,
      y: y,
      width: width,
      height: height,
      fontName: fontName,
      fontSize: fontSize,
      isBold: isBold,
      isItalic: isItalic,
      rotate: rotate,
      style: style,
      format: format,
    );
  }

  Future<int?> prnDrawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    return PosPrinterPlatform.instance.prnDrawBarcode(
      data: data,
      x: x,
      y: y,
      barcodeType: barcodeType,
      width: width,
      height: height,
      rotate: rotate,
    );
  }

  Future<int?> prnDrawBitmap(
      {required Bitmap bitmap, required int xDest, required int yDest}) {
    return PosPrinterPlatform.instance.prnDrawBitmap(
      bitmap: bitmap,
      xDest: xDest,
      yDest: yDest,
    );
  }

  Future<int?> getTemp() {
    return PosPrinterPlatform.instance.getTemp();
  }

  Future<int?> printCachedPage() {
    return PosPrinterPlatform.instance.printCachedPage();
  }
}

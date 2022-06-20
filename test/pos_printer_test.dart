import 'package:bitmap/src/bitmap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer/pos_printer.dart';
import 'package:pos_printer/pos_printer_platform_interface.dart';
import 'package:pos_printer/pos_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPosPrinterPlatform
    with MockPlatformInterfaceMixin
    implements PosPrinterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> clearPage() {
    // TODO: implement clearPage
    throw UnimplementedError();
  }

  @override
  Future<int?> dispose() {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<int?> drawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    // TODO: implement drawBarcode
    throw UnimplementedError();
  }

  @override
  Future<int?> drawBitmap(
      {required Bitmap bitmap, required int xDest, required int yDest}) {
    // TODO: implement drawBitmap
    throw UnimplementedError();
  }

  @override
  Future<int?> drawBitmapEx(
      {required List<int> bytes,
      required int xDest,
      required int yDest,
      required int widthDest,
      required int heightDest}) {
    // TODO: implement drawBitmapEx
    throw UnimplementedError();
  }

  @override
  Future<int?> drawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    // TODO: implement drawLine
    throw UnimplementedError();
  }

  @override
  Future<int?> drawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    // TODO: implement drawText
    throw UnimplementedError();
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
      required int format}) {
    // TODO: implement drawTextEx
    throw UnimplementedError();
  }

  @override
  Future<int?> getStatus() {
    // TODO: implement getStatus
    throw UnimplementedError();
  }

  @override
  Future<int?> getTemp() {
    // TODO: implement getTemp
    throw UnimplementedError();
  }

  @override
  Future<int?> paperFeed(int length) {
    // TODO: implement paperFeed
    throw UnimplementedError();
  }

  @override
  Future<String?> print() {
    // TODO: implement print
    throw UnimplementedError();
  }

  @override
  Future<int?> printCachedPage() {
    // TODO: implement printCachedPage
    throw UnimplementedError();
  }

  @override
  Future<int?> printPage(int rotate) {
    // TODO: implement printPage
    throw UnimplementedError();
  }

  @override
  Future<int?> prnClearPage() {
    // TODO: implement prnClearPage
    throw UnimplementedError();
  }

  @override
  Future<int?> prnClose() {
    // TODO: implement prnClose
    throw UnimplementedError();
  }

  @override
  Future<int?> prnDrawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    // TODO: implement prnDrawBarcode
    throw UnimplementedError();
  }

  @override
  Future<int?> prnDrawBitmap(
      {required Bitmap bitmap, required int xDest, required int yDest}) {
    // TODO: implement prnDrawBitmap
    throw UnimplementedError();
  }

  @override
  Future<int?> prnDrawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    // TODO: implement prnDrawLine
    throw UnimplementedError();
  }

  @override
  Future<int?> prnDrawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    // TODO: implement prnDrawText
    throw UnimplementedError();
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
      required int format}) {
    // TODO: implement prnDrawTextEx
    throw UnimplementedError();
  }

  @override
  Future<int?> prnGetStatus() {
    // TODO: implement prnGetStatus
    throw UnimplementedError();
  }

  @override
  Future<int?> prnGetTemp() {
    // TODO: implement prnGetTemp
    throw UnimplementedError();
  }

  @override
  Future<int?> prnOpen() {
    // TODO: implement prnOpen
    throw UnimplementedError();
  }

  @override
  Future<int?> prnPaperBack(int length) {
    // TODO: implement prnPaperBack
    throw UnimplementedError();
  }

  @override
  Future<int?> prnPaperForWard(int length) {
    // TODO: implement prnPaperForWard
    throw UnimplementedError();
  }

  @override
  Future<int?> prnPrintPage(int rotate) {
    // TODO: implement prnPrintPage
    throw UnimplementedError();
  }

  @override
  Future<int?> prnSetBlack(int level) {
    // TODO: implement prnSetBlack
    throw UnimplementedError();
  }

  @override
  Future<int?> prnSetSpeed(int level) {
    // TODO: implement prnSetSpeed
    throw UnimplementedError();
  }

  @override
  Future<int?> prnSetupPage({required int width, required int height}) {
    // TODO: implement prnSetupPage
    throw UnimplementedError();
  }

  @override
  Future<int?> setGrayLevel(int level) {
    // TODO: implement setGrayLevel
    throw UnimplementedError();
  }

  @override
  Future<int?> setSpeedLevel(int level) {
    // TODO: implement setSpeedLevel
    throw UnimplementedError();
  }

  @override
  Future<int?> setupPage({required int height, required int width}) {
    // TODO: implement setupPage
    throw UnimplementedError();
  }
}

void main() {
  final PosPrinterPlatform initialPlatform = PosPrinterPlatform.instance;

  test('$MethodChannelPosPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPosPrinter>());
  });

  test('getPlatformVersion', () async {
    PosPrinter posPrinterPlugin = PosPrinter();
    MockPosPrinterPlatform fakePlatform = MockPosPrinterPlatform();
    PosPrinterPlatform.instance = fakePlatform;

    expect(await posPrinterPlugin.getPlatformVersion(), '42');
  });
}

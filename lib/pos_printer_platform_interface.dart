import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pos_printer_method_channel.dart';

abstract class PosPrinterPlatform extends PlatformInterface {
  /// Constructs a PosPrinterPlatform.
  PosPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PosPrinterPlatform _instance = MethodChannelPosPrinter();

  /// The default instance of [PosPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelPosPrinter].
  static PosPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PosPrinterPlatform] when
  /// they register themselves.
  static set instance(PosPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> print() {
    throw UnimplementedError('print() has not been implemented.');
  }

  /// gets printers status
  Future<int?> getStatus() {
    throw UnimplementedError('getStatus() has not been implemented');
  }

  /// close printer
  Future<int?> dispose() {
    throw UnimplementedError('dispose() has not been implemented');
  }

  /// sets printer up for printing
  Future<int?> setupPage({required int height, required int width}) {
    throw UnimplementedError('setupPage() has not been implemented');
  }

  /// set gray level for printer
  Future<int?> setGrayLevel(int level) {
    throw UnimplementedError(
        'setGrayLevel(int level) has not been implemented');
  }

  /// length of paper in printer
  Future<int?> paperFeed(int length) {
    throw UnimplementedError('paperFeed(int length) has not been implemented');
  }

  /// speed of priner
  /// ranges from 0 to 9
  Future<int?> setSpeedLevel(int level) {
    throw UnimplementedError(
        'setSpeedLevel(int level) has not been implemented');
  }

  ///resets page setup or clears page set up
  Future<int?> clearPage() {
    throw UnimplementedError('clearPage() has not been implemented');
  }

  /// print page

  Future<int?> printPage(int rotate) {
    throw UnimplementedError('printPage(int rotate) has not been implemented');
  }

  /// drawline
  Future<int?> drawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    throw UnimplementedError(
        'drawLine({required int x0,required int  y0, required int x1,required int y1, required int lineWidth}) has not been implemented');
  }

  /// drawText
  Future<int?> drawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    throw UnimplementedError(
        'drawText({required String data, required int x, required int y, required String fontName, required bool isBold, required bool isItalic, required int rotate }) has not been implemented');
  }

  /// drawTextEx
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
    throw UnimplementedError(
        'drawTextEx({required String data, required int x, required int y,required int width, required int height, required String fontName,required int fontSize, required bool isBold, required bool isItalic, required int rotate, required int style,required int format }) has not been implemented');
  }

  /// drawBarcode
  Future<int?> drawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    throw UnimplementedError(
        'drawBarcode({required String data, required int x, required int y, required int barcodeType, required int width, required int height, required int rotate}) has not been implemented');
  }

  /// draw image
  Future<int?> drawBitmap(
      {required String image, required int xDest, required int yDest}) {
    throw UnimplementedError(
        'drawBitmap({required Bitmap bitmap, required int xDest, required int yDest}) has not been implemented');
  }

  /// draw image ex
  Future<int?> drawBitmapEx(
      {required List<int> bytes,
      required int xDest,
      required int yDest,
      required int widthDest,
      required int heightDest}) {
    throw UnimplementedError(
        'drawBitmapEx({required List<int> bytes, required int xDest, required int yDest,required int widthDest, required int heightDest}) has not been implemented');
  }

  /// prn_open
  Future<int?> prnOpen() {
    throw UnimplementedError('prnOpen() has not been implemented');
  }

  /// prn_close
  Future<int?> prnClose() {
    throw UnimplementedError('prnClose() has not been implemented');
  }

  /// prn_setBlack
  Future<int?> prnSetBlack(int level) {
    throw UnimplementedError('prnSetBlack(int level) has not been implemented');
  }

  ///prn_paperForWard
  Future<int?> prnPaperForWard(int length) {
    throw UnimplementedError(
        'prnPaperForWard(int length) has not been implemented');
  }

  /// prn_paperBack
  Future<int?> prnPaperBack(int length) {
    throw UnimplementedError(
        'prnPaperForWard(int length) has not been implemented');
  }

  ///   prn_setSpeed
  ///   sets printer speed [0 - 9]
  Future<int?> prnSetSpeed(int level) {
    throw UnimplementedError('prnSetSpeed(int level) has not been implemented');
  }

  ///prn_getTemp
  /// gets temperature of printer
  Future<int?> prnGetTemp() {
    throw UnimplementedError('prnGetTemp() has not been implemented');
  }

  ///prn_setupPage
  ///set up page with width and height
  Future<int?> prnSetupPage({required int width, required int height}) {
    throw UnimplementedError(
        'prnSetupPage({required int width, required int height}) has not been implemented');
  }

  /// prn_clearPage
  /// clears page
  Future<int?> prnClearPage() {
    throw UnimplementedError('prnClearPage() has not been implemented');
  }

  ///prn_printPage
  ///prints page
  Future<int?> prnPrintPage(int rotate) {
    throw UnimplementedError('prnPrintPage() has not been implemented');
  }

  ///prn_drawLine
  /// draw lines
  Future<int?> prnDrawLine(
      {required int x0,
      required int y0,
      required int x1,
      required int y1,
      required int lineWidth}) {
    throw UnimplementedError(
        'prnDrawLine({required int x0, required int y0, required int  x1, required int y1, required int lineWidth})has not been implemented');
  }

  /// prn_drawText
  /// draws text
  Future<int?> prnDrawText(
      {required String data,
      required int x,
      required int y,
      required String fontName,
      required int fontSize,
      required bool isBold,
      required bool isItalic,
      required int rotate}) {
    throw UnimplementedError(
        'prnDrawText({required String data, required int x, required int y, required String fontName, required bool isBold, required bool isItalic, required int rotate }) has not been implemented');
  }

  ///prn_drawTextEx
  ///
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
    throw UnimplementedError(
        'prnDrawTextEx({required String data, required int x, required int y,required int width, required int height, required String fontName,required int fontSize, required bool isBold, required bool isItalic, required int rotate, required int style,required int format }) has not been implemented');
  }

  /// prn_drawBarcode
  Future<int?> prnDrawBarcode(
      {required String data,
      required int x,
      required int y,
      required int barcodeType,
      required int width,
      required int height,
      required int rotate}) {
    throw UnimplementedError(
        'prnDrawBarcode({required String data, required int x, required int y, required int barcodeType, required int width, required int height, required int rotate}) has not been implemented');
  }

  /// prn_drawBarcode
  Future<int?> prnDrawBitmap(
      {required String image, required int xDest, required int yDest}) {
    throw UnimplementedError(
        'prnDrawBitmap({required Bitmap bitmap, required int xDest, required int yDest}) has not been implemented');
  }

  /// prn_getStatus
  Future<int?> prnGetStatus() {
    throw UnimplementedError('prnGetStatus() has not been implemented');
  }

  /// getTemp
  Future<int?> getTemp() {
    throw UnimplementedError('getTemp() has not been implemented');
  }

  /// printCachedPage
  Future<int?> printCachedPage() {
    throw UnimplementedError('printCachedPage() has not been implemented');
  }
}

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer/pos_printer.dart';
import 'package:pos_printer/pos_printer_method_channel.dart';

void main() {
  MethodChannelPosPrinter platform = MethodChannelPosPrinter();
  const MethodChannel channel = MethodChannel('pos_printer');

  TestWidgetsFlutterBinding.ensureInitialized();

  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      calls.add(methodCall);
      return 0;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => '42');
    expect(await platform.getPlatformVersion(), '42');
  });

  test('paperFeed forwards its length argument', () async {
    await platform.paperFeed(120);
    expect(calls.single.method, 'paperFeed');
    expect((calls.single.arguments as Map)['length'], 120);
  });

  test('setSpeedLevel forwards its level argument', () async {
    await platform.setSpeedLevel(7);
    expect((calls.single.arguments as Map)['level'], 7);
  });

  test('prnDrawText includes fontSize', () async {
    await platform.prnDrawText(
      data: 'hi',
      x: 1,
      y: 2,
      fontName: 'simsun',
      fontSize: 24,
      isBold: false,
      isItalic: false,
      rotate: 0,
    );
    expect((calls.single.arguments as Map)['fontSize'], 24);
  });

  test('drawBarcode key matches what native reads', () async {
    await platform.drawBarcode(
      data: '123',
      x: 0,
      y: 0,
      barcodeType: 4,
      width: 100,
      height: 40,
      rotate: 0,
    );
    expect((calls.single.arguments as Map).containsKey('barcodeType'), isTrue);
  });

  test('statusMessage maps known codes', () {
    expect(PosPrinter.statusMessage(PosPrinter.statusOk), 'OK');
    expect(PosPrinter.statusMessage(PosPrinter.statusOutOfPaper), 'Out of paper');
    expect(PosPrinter.statusMessage(PosPrinter.statusBusy), 'Printer busy');
    expect(PosPrinter.statusMessage(null), 'No response from printer');
    expect(PosPrinter.statusMessage(-999), 'Printer error (-999)');
  });
}

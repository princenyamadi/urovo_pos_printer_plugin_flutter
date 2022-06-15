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

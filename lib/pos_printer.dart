
import 'pos_printer_platform_interface.dart';

class PosPrinter {
  Future<String?> getPlatformVersion() {
    return PosPrinterPlatform.instance.getPlatformVersion();
  }
}

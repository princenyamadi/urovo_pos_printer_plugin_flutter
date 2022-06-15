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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

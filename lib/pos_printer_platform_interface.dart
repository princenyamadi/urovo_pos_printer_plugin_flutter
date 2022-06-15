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
}

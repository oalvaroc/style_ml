import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:image/image.dart';

import 'style_ml_tflite_method_channel.dart';

abstract class StyleMlTflitePlatform extends PlatformInterface {
  /// Constructs a StyleMlTflitePlatform.
  StyleMlTflitePlatform() : super(token: _token);

  static final Object _token = Object();

  static StyleMlTflitePlatform _instance = MethodChannelStyleMlTflite();

  /// The default instance of [StyleMlTflitePlatform] to use.
  ///
  /// Defaults to [MethodChannelStyleMlTflite].
  static StyleMlTflitePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StyleMlTflitePlatform] when
  /// they register themselves.
  static set instance(StyleMlTflitePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Image?> transfer(Image styleImage, Image contentImage) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'style_ml_tflite_platform_interface.dart';

/// An implementation of [StyleMlTflitePlatform] that uses method channels.
class MethodChannelStyleMlTflite extends StyleMlTflitePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('style_ml_tflite');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Uint8List?> transfer(
      Uint8List styleImage, Uint8List contentImage, double ratio) async {
    final result = await methodChannel.invokeMethod<Uint8List>(
      'transfer',
      {
        'styleImage': styleImage,
        'contentImage': contentImage,
        'ratio': ratio,
      },
    );
    return result;
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';

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
  Future<Image?> transfer(Image styleImage, Image contentImage) async {
    final style = JpegEncoder().encode(styleImage);
    final content = JpegEncoder().encode(contentImage);

    final result = await methodChannel.invokeMethod<Uint8List>(
      'transfer',
      {'styleImage': style, 'contentImage': content},
    );

    if (result != null) {
      return JpegDecoder().decode(result);
    }

    return Image.empty();
  }
}

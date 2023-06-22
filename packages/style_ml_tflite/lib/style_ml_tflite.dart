import 'dart:typed_data';

import 'style_ml_tflite_platform_interface.dart';

class StyleMlTflite {
  Future<String?> getPlatformVersion() {
    return StyleMlTflitePlatform.instance.getPlatformVersion();
  }

  Future<Uint8List?> transfer(
      Uint8List styleImage, Uint8List contentImage, double ratio) {
    return StyleMlTflitePlatform.instance
        .transfer(styleImage, contentImage, ratio);
  }
}

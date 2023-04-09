import 'package:image/image.dart';

import 'style_ml_tflite_platform_interface.dart';

class StyleMlTflite {
  Future<String?> getPlatformVersion() {
    return StyleMlTflitePlatform.instance.getPlatformVersion();
  }

  Future<Image?> transfer(Image styleImage, Image contentImage) {
    return StyleMlTflitePlatform.instance.transfer(styleImage, contentImage);
  }
}

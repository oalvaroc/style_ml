import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Future<img.Image> decodeJpg(Uint8List bytes) async {
    return await compute(_decodeJpg, bytes);
  }

  static Future<Uint8List> encodeJpg(img.Image image,
      {int quality = 100}) async {
    return await compute(
      _encodeJpg,
      _EncoderParams(
        image: image,
        quality: quality,
      ),
    );
  }

  static Future<Uint8List> fixOrientation(Uint8List image) async {
    return await compute(_fixOrientation, image);
  }

  static img.Image _decodeJpg(Uint8List bytes) {
    return img.decodeJpg(bytes)!;
  }

  static Uint8List _encodeJpg(_EncoderParams params) {
    return img.encodeJpg(params.image, quality: params.quality);
  }

  static Uint8List _fixOrientation(Uint8List bytes) {
    final original = _decodeJpg(bytes);
    final fixed = img.bakeOrientation(original);
    return _encodeJpg(_EncoderParams(image: fixed, quality: 100));
  }
}

class _EncoderParams {
  _EncoderParams({required this.image, required this.quality});

  final img.Image image;
  final int quality;
}

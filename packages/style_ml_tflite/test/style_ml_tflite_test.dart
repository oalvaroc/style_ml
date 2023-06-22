import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:style_ml_tflite/style_ml_tflite.dart';
import 'package:style_ml_tflite/style_ml_tflite_platform_interface.dart';
import 'package:style_ml_tflite/style_ml_tflite_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockStyleMlTflitePlatform
    with MockPlatformInterfaceMixin
    implements StyleMlTflitePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<Uint8List?> transfer(
      Uint8List styleImage, Uint8List contentImage, double ratio) {
    return Future.delayed(
        const Duration(milliseconds: 500), () => Uint8List(1));
  }
}

void main() {
  final StyleMlTflitePlatform initialPlatform = StyleMlTflitePlatform.instance;

  test('$MethodChannelStyleMlTflite is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelStyleMlTflite>());
  });

  test('getPlatformVersion', () async {
    StyleMlTflite styleMlTflitePlugin = StyleMlTflite();
    MockStyleMlTflitePlatform fakePlatform = MockStyleMlTflitePlatform();
    StyleMlTflitePlatform.instance = fakePlatform;

    expect(await styleMlTflitePlugin.getPlatformVersion(), '42');
  });
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key, this.onPicture});

  final void Function(img.Image)? onPicture;

  @override
  State<StatefulWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraLensDirection _lensDirection = CameraLensDirection.back;
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final deviceRatio = MediaQuery.of(context).size.aspectRatio;
    final cameraRatio = _controller!.value.aspectRatio;

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1 / cameraRatio,
            child: CameraPreview(_controller!),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () {
                    _flipCamera();
                  },
                  child: const Icon(Icons.flip_camera_android),
                ),
                FloatingActionButton(
                  onPressed: () {
                    _takePicture();
                  },
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == _lensDirection,
    );
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller.initialize();
    await controller.setFlashMode(FlashMode.off);

    setState(() {
      _cameras = cameras;
      _controller = controller;
      _isCameraReady = true;
    });
  }

  Future<void> _flipCamera() async {
    setState(() {
      _isCameraReady = false;
      _lensDirection = _lensDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    });

    await _controller?.dispose();

    final selectedCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == _lensDirection,
    );
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    await controller.initialize();
    await controller.setFlashMode(FlashMode.off);

    setState(() {
      _controller = controller;
      _isCameraReady = true;
    });
  }

  Future<void> _takePicture() async {
    final imageFile = await _controller!.takePicture();
    final image = await imageFile
        .readAsBytes()
        .then((bytes) => img.JpegDecoder().decode(bytes))
        .then((image) => _lensDirection == CameraLensDirection.front
            ? img.flipHorizontal(image!)
            : image!);

    debugPrint('>> saved: ${imageFile.path}');

    if (widget.onPicture != null) {
      widget.onPicture!(image);
    }
  }
}

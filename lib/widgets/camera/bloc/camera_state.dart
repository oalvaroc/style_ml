part of 'camera_bloc.dart';

@immutable
class CameraState {
  const CameraState._({
    this.cameras,
    this.currentCamera,
    this.controller,
    this.image,
  });

  const CameraState.initial() : this._();

  const CameraState({
    required this.cameras,
    required this.currentCamera,
    required this.controller,
    this.image,
  });

  final List<CameraDescription>? cameras;
  final CameraDescription? currentCamera;
  final CameraController? controller;
  final img.Image? image;

  CameraState copyWith({
    List<CameraDescription>? cameras,
    CameraDescription? currentCamera,
    CameraController? controller,
    img.Image? image,
  }) {
    return CameraState(
      cameras: cameras ?? this.cameras,
      currentCamera: currentCamera ?? this.currentCamera,
      controller: controller ?? this.controller,
      image: image ?? this.image,
    );
  }
}

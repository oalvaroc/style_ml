import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart' as img;

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(const CameraState.initial()) {
    on<CameraStarted>(_onStarted);
    on<CameraFlipped>(_onFlipped);
    on<CameraPictureTaken>(_onPictureTaken);
  }

  bool isInitialized = false;

  @override
  Future<void> close() async {
    state.controller?.dispose();
    isInitialized = false;
    super.close();
  }

  Future<void> _onPictureTaken(
    CameraPictureTaken event,
    Emitter<CameraState> emit,
  ) async {
    final imageFile = await state.controller!.takePicture();
    final image = await imageFile
        .readAsBytes()
        .then((bytes) => img.JpegDecoder().decode(bytes))
        .then((image) =>
            state.currentCamera!.lensDirection == CameraLensDirection.front
                ? img.flipHorizontal(image!)
                : image!);

    emit(state.copyWith(image: image));
  }

  Future<void> _onStarted(
    CameraStarted event,
    Emitter<CameraState> emit,
  ) async {
    final newState = await _initCamera(CameraLensDirection.back);
    emit(newState);
  }

  Future<void> _onFlipped(
    CameraFlipped event,
    Emitter<CameraState> emit,
  ) async {
    await state.controller!.dispose();

    final currentDirection = state.currentCamera!.lensDirection;
    final newDirection = currentDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;

    final newState = await _initCamera(newDirection);
    emit(newState);
  }

  Future<CameraState> _initCamera(CameraLensDirection lensDirection) async {
    final cameras = state.cameras ?? await availableCameras();
    final selectedCamera =
        cameras.firstWhere((camera) => camera.lensDirection == lensDirection);
    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await controller.initialize();
    await controller.setFlashMode(FlashMode.off);

    isInitialized = true;

    return CameraState(
      cameras: cameras,
      currentCamera: selectedCamera,
      controller: controller,
    );
  }
}

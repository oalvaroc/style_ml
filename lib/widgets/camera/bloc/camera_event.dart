part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {}

class CameraStarted extends CameraEvent {}

class CameraFlipped extends CameraEvent {}

class CameraPictureTaken extends CameraEvent {}

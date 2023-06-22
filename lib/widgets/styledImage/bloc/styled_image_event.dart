part of 'styled_image_bloc.dart';

@immutable
abstract class StyledImageEvent {}

class StyledImageSourceChanged extends StyledImageEvent {
  StyledImageSourceChanged(this.image);

  final Uint8List image;
}

class StyledImageStyleChanged extends StyledImageEvent {
  StyledImageStyleChanged(this.style);

  final StyleNames style;
}

class StyledImageMixRatioChanged extends StyledImageEvent {
  StyledImageMixRatioChanged(this.ratio);

  final double ratio;
}

class StyledImageRun extends StyledImageEvent {}

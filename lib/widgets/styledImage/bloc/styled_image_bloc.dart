import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:style_ml/utils/image.dart';
import 'package:style_ml_tflite/style_ml_tflite.dart';

part 'styled_image_event.dart';
part 'styled_image_state.dart';

class StyledImageBloc extends Bloc<StyledImageEvent, StyledImageState> {
  static final _styleTransfer = StyleMlTflite();
  final img.Image source;

  StyledImageBloc({required this.source})
      : super(StyledImageState.initial(source: source)) {
    on<StyledImageSourceChanged>(_onSourceChanged);
    on<StyledImageMixRatioChanged>(_onMixRatioChanged);
    on<StyledImageStyleChanged>(_onStyleChanged);
    on<StyledImageRun>(_onRun);
  }

  void _onSourceChanged(
    StyledImageSourceChanged event,
    Emitter<StyledImageState> emit,
  ) {
    emit(state.copyWith(source: event.image));
    add(StyledImageRun());
  }

  void _onMixRatioChanged(
    StyledImageMixRatioChanged event,
    Emitter<StyledImageState> emit,
  ) {
    emit(state.copyWith(mixRatio: event.ratio));
  }

  void _onStyleChanged(
    StyledImageStyleChanged event,
    Emitter<StyledImageState> emit,
  ) {
    emit(state.copyWith(style: event.style));
  }

  Future<void> _onRun(
    StyledImageRun event,
    Emitter<StyledImageState> emit,
  ) async {
    if (!state.isRunning) {
      emit(state.copyWith(isRunning: true));
      final result = await _runStyleTransfer(state);
      emit(state.copyWith(result: result, isRunning: false));
    }
  }

  static Future<Uint8List?> _runStyleTransfer(StyledImageState state) async {
    if (state.source == null || state.style == null || state.mixRatio == null) {
      return state.result;
    }

    final contentImage = await ImageUtils.encodeJpg(state.source!);
    final styleImage = await rootBundle
        .load(state.style!.path)
        .then((asset) => asset.buffer.asUint8List());

    final resImage = await _styleTransfer.transfer(
      styleImage,
      contentImage,
      state.mixRatio!,
    );
    return resImage;
  }
}

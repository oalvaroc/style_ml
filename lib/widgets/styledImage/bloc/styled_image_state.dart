part of 'styled_image_bloc.dart';

enum StyleNames {
  monalisa(path: 'assets/davinci-mona-lisa.jpg'),
  blackAndViolet(path: 'assets/kandinsky-black-and-violet.jpg'),
  sunrise(path: 'assets/monet-sunrise.jpg'),
  starryNight(path: 'assets/van-gogh-starry-night.jpg'),
  colorStudy(path: 'assets/kandinsky-color-study.jpg'),
  theScream(path: 'assets/munch-the-scream.jpg');

  const StyleNames({
    required this.path,
  });

  final String path;
}

@immutable
class StyledImageState {
  const StyledImageState._({
    this.source,
    this.style,
    this.mixRatio,
    this.result,
    this.isRunning = false,
  });

  const StyledImageState.initial({required Uint8List source})
      : this._(source: source, style: StyleNames.monalisa, mixRatio: 0.5);

  const StyledImageState({
    required this.source,
    required this.style,
    required this.mixRatio,
    required this.result,
    required this.isRunning,
  });

  final Uint8List? source;
  final Uint8List? result;
  final StyleNames? style;
  final double? mixRatio;
  final bool isRunning;

  StyledImageState copyWith({
    Uint8List? source,
    Uint8List? result,
    StyleNames? style,
    double? mixRatio,
    bool? isRunning,
  }) {
    return StyledImageState(
      source: source ?? this.source,
      result: result ?? this.result,
      style: style ?? this.style,
      mixRatio: mixRatio ?? this.mixRatio,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

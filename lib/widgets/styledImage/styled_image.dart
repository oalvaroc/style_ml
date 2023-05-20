import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/styled_image_bloc.dart';

class StyledImage extends StatefulWidget {
  const StyledImage({super.key});

  final double size = 384;

  @override
  State<StyledImage> createState() => _StyledImageState();
}

class _StyledImageState extends State<StyledImage> {
  final _box = Hive.box('style');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyledImageBloc, StyledImageState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<StyledImageBloc>(context);

        if (state.isRunning || state.result == null) {
          if (state.result == null) {
            if (_box.isNotEmpty) {
              final index = _box.get('style-index');
              bloc.add(StyledImageStyleChanged(StyleNames.values[index]));
            }
            bloc.add(StyledImageRun());
          }

          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Image.memory(state.result!),
        );
      },
    );
  }
}

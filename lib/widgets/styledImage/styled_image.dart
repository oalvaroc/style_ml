import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/styled_image_bloc.dart';

class StyledImage extends StatefulWidget {
  const StyledImage({super.key});

  final double size = 384;

  @override
  State<StyledImage> createState() => _StyledImageState();
}

class _StyledImageState extends State<StyledImage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StyledImageBloc, StyledImageState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<StyledImageBloc>(context);

        if (state.isRunning || state.result == null) {
          if (state.result == null) {
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

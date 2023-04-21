import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/camera/bloc/camera_bloc.dart';
import '../widgets/camera/camera.dart';
import 'style_page.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocProvider(
        create: (context) => CameraBloc(),
        child: BlocListener<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state.image != null) {
              Navigator.of(context).pushNamed(
                '/style',
                arguments: StylePageArgs(state.image!),
              );
            }
          },
          child: const CameraWidget(),
        ),
      ),
    );
  }
}

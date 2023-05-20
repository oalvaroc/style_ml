import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/camera_bloc.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<CameraBloc>(context);

        if (!bloc.isInitialized) {
          bloc.add(CameraStarted());
          return const Center(child: CircularProgressIndicator());
        }

        final cameraRatio = state.controller!.value.aspectRatio;

        return Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 1 / cameraRatio,
                  child: CameraPreview(state.controller!),
                ),
                Container(
                  width: 384,
                  height: 384,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          bloc.add(CameraFlipped());
                        },
                        icon: const Icon(
                          Icons.flip_camera_android,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          bloc.add(CameraPictureTaken());
                        },
                        icon: const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 100,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

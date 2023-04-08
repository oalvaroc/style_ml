import 'dart:io';

import 'package:flutter/material.dart';
import 'camera.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleIt',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const CameraPage(),
        '/style': (context) => const StylePage(),
      },
    );
  }
}

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraWidget(
        onPicture: (String imagePath) {
          Navigator.of(context).pushNamed(
            '/style',
            arguments: StylePageArgs(imagePath),
          );
        },
      ),
    );
  }
}

class StylePage extends StatefulWidget {
  const StylePage({super.key});

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as StylePageArgs;

    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Image.file(File(args.imagePath)),
          ),
          ElevatedButton(
            child: const Text('Go back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class StylePageArgs {
  StylePageArgs(this.imagePath);

  final String imagePath;
}

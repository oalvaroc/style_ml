import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:style_ml_tflite/style_ml_tflite.dart';

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
        '/style': (context) => StylePage(),
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
        onPicture: (img.Image image) {
          Navigator.of(context).pushNamed(
            '/style',
            arguments: StylePageArgs(image),
          );
        },
      ),
    );
  }
}

class StylePage extends StatefulWidget {
  StylePage({super.key});

  final styleTransfer = StyleMlTflite();
  final styleNames = [
    'davinci-mona-lisa',
    'kandinsky-black-and-violet',
    'monet-sunrise',
    'van-gogh-starry-night'
  ];

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  int _styleSelected = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as StylePageArgs;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: runStyleTransfer(args.image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final imageBytes = img.JpegEncoder().encode(snapshot.data!);

                  return Image.memory(imageBytes);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(100),
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Container(
              //width: MediaQuery.of(context).size.width,
              height: 200,
              padding: const EdgeInsets.all(10),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.styleNames.length,
                itemBuilder: ((context, index) {
                  final name = widget.styleNames[index];
                  return GestureDetector(
                    child: Image.asset('assets/$name.jpg'),
                    onTap: () {
                      setState(() {
                        _styleSelected = index;
                      });
                    },
                  );
                }),
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
              ),
            ),
            ElevatedButton(
              child: const Text('Go back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<img.Image?> runStyleTransfer(img.Image contentImage) async {
    final styleImage = await rootBundle
        .load('assets/${widget.styleNames[_styleSelected]}.jpg')
        .then((asset) => asset.buffer.asUint8List())
        .then((bytes) => img.JpegDecoder().decode(bytes));

    return await widget.styleTransfer.transfer(styleImage!, contentImage);
  }
}

class StylePageArgs {
  StylePageArgs(this.image);

  final img.Image image;
}

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
  const StylePage({super.key});

  @override
  State<StylePage> createState() => _StylePageState();
}

class _StylePageState extends State<StylePage> {
  static final _styleTransfer = StyleMlTflite();
  final _styleNames = [
    'davinci-mona-lisa',
    'kandinsky-black-and-violet',
    'monet-sunrise',
    'van-gogh-starry-night'
  ];
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
                itemCount: _styleNames.length,
                itemBuilder: ((context, index) {
                  final name = _styleNames[index];
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
        .load('assets/${_styleNames[_styleSelected]}.jpg')
        .then((asset) => asset.buffer.asUint8List())
        .then((bytes) => img.JpegDecoder().decode(bytes));

    return _styleTransfer.transfer(styleImage!, contentImage);
  }
}

class StylePageArgs {
  StylePageArgs(this.image);

  final img.Image image;
}

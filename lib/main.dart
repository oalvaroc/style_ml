import 'package:flutter/material.dart';
import 'pages/camera_page.dart';
import 'pages/style_page.dart';

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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/pages/home_page.dart';
import 'pages/camera_page.dart';
import 'pages/login_page.dart';
import 'pages/style_page.dart';
import 'widgets/galleryGrid/bloc/gallery_posts_bloc.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GalleryPostsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'StyleIt',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const LoginPage(),
          '/camera': (context) => const CameraPage(),
          '/home': (context) => const HomePage(),
          '/style': (context) => const StylePage(),
        },
      ),
    );
  }
}

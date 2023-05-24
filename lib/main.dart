import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/bloc/post_monitor_bloc.dart';
import 'package:style_ml/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:style_ml/widgets/loginForm/bloc/login_bloc.dart';

import 'pages/about_page.dart';
import 'pages/camera_page.dart';
import 'pages/login_page.dart';
import 'pages/style_page.dart';
//import 'widgets/galleryGrid/bloc/gallery_posts_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('login');
  await Hive.openBox('style');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => PostManagerBloc()),
        BlocProvider(create: (context) => PostMonitorBloc()),
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
          '/about': (context) => const AboutPage(),
        },
      ),
    );
  }
}

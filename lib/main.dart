import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/bloc/post_monitor_bloc.dart';
import 'package:style_ml/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:style_ml/pages/register_page.dart';
import 'package:style_ml/providers/firebase_auth_provider.dart';
import 'package:style_ml/providers/provider_factory.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'pages/about_page.dart';
import 'pages/login_page.dart';
import 'pages/style_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await Hive.openBox('login');
  await Hive.openBox('style');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider())),
        BlocProvider(
          create: (context) =>
              PostManagerBloc(FirestoreProviderFactory.instance.provider),
        ),
        BlocProvider(
          create: (context) =>
              PostMonitorBloc(FirestoreProviderFactory.instance.provider),
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
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/style': (context) => const StylePage(),
          '/about': (context) => const AboutPage(),
        },
      ),
    );
  }
}

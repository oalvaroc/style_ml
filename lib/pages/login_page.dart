import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';

import '../widgets/loginForm/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).popAndPushNamed('/home');
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'StyleML',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: LoginForm(),
              ),
              TextButton(
                child: const Text("Register now"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/register");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

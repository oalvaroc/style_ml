import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/loginForm/bloc/login_bloc.dart';
import '../widgets/loginForm/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.of(context).pushNamed('/camera');
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'StyleML',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
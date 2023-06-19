import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';

import '../widgets/registerForm/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
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
                  child: RegisterForm(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

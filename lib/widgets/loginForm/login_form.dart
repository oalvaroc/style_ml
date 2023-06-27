import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email = "";
  String _password = "";
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<AuthBloc>(context);

        return Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _email.isNotEmpty && _password.isNotEmpty
                            ? () async {
                                bloc.add(
                                  SignInEvent(
                                    email: _email,
                                    password: _password,
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

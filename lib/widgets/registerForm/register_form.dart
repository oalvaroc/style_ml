import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _canSubmit() {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
        (_password == _passwordConfirmation);
  }

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
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )),
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _passwordConfirmation = value;
                  });
                },
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                    label: const Text('Confirm Password'),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(_isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _canSubmit()
                            ? () {
                                bloc.add(
                                  RegisterEvent(
                                    email: _email,
                                    password: _password,
                                  ),
                                );
                              }
                            : null,
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

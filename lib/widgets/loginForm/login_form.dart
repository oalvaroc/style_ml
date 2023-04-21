import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final bloc = BlocProvider.of<LoginBloc>(context);

        return Form(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  bloc.add(LoginEmailChanged(value));
                },
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  bloc.add(LoginPasswordChanged(value));
                },
                obscureText: !state.isPasswordVisible,
                decoration: InputDecoration(
                  label: const Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      bloc.add(LoginPasswordVisibilityToggled());
                    },
                    icon: Icon(
                      state.isPasswordVisible
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
                        onPressed: !state.isComplete
                            ? null
                            : () {
                                bloc.add(LoginSubmitted());
                              },
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

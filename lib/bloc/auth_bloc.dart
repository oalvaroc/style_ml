import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/providers/auth_provider.dart';

import '../models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _provider;

  AuthBloc(this._provider) : super(Unauthenticated()) {
    _provider.stream.listen((user) {
      print('Firebase auth: ${user?.uid}');
      add(AuthServerEvent(user: user));
    });

    on<AuthServerEvent>((event, emit) {
      if (event.user != null) {
        emit(Authenticated(user: event.user!));
      } else {
        emit(Unauthenticated());
      }
    });
    on<RegisterEvent>((event, emit) async {
      try {
        await _provider.createUser(event.email, event.password);
      } on AuthProviderException catch (e) {
        emit(AuthError(msg: e.message));
      }
    });
    on<SignInEvent>((event, emit) async {
      try {
        await _provider.signIn(event.email, event.password);
      } on AuthProviderException catch (e) {
        emit(AuthError(msg: e.message));
      }
    });
    on<SignOutEvent>((event, emit) async {
      await _provider.signOut();
    });
  }
}

// events
abstract class AuthEvent {}

class AuthServerEvent extends AuthEvent {
  AuthServerEvent({required this.user});

  final UserModel? user;
}

class RegisterEvent extends AuthEvent {
  RegisterEvent({required this.email, required this.password});

  final String email;
  final String password;
}

class SignInEvent extends AuthEvent {
  SignInEvent({required this.email, required this.password});

  final String email;
  final String password;
}

class SignOutEvent extends AuthEvent {}

// states
abstract class AuthState {}

class Unauthenticated extends AuthState {}

class Authenticated extends AuthState {
  Authenticated({required this.user});

  final UserModel user;
}

class AuthError extends AuthState {
  AuthError({required this.msg});

  final String msg;
}

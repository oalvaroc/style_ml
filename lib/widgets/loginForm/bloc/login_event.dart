part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginPasswordVisibilityToggled extends LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  LoginEmailChanged(this.email);

  final String email;
}

class LoginPasswordChanged extends LoginEvent {
  LoginPasswordChanged(this.password);

  final String password;
}

class LoginSubmitted extends LoginEvent {}

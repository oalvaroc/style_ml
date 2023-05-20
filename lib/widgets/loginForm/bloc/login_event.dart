part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

class LoginRestored extends LoginEvent {
  LoginRestored(this.email, this.password);

  final String email;
  final String password;
}

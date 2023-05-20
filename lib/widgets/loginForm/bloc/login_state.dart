part of 'login_bloc.dart';

enum LoginStatus {
  success,
  failure,
  notSubmitted,
}

@immutable
abstract class LoginState {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
  });

  const LoginState.initial()
      : this(
          email: '',
          password: '',
          status: LoginStatus.notSubmitted,
        );

  final String email;
  final String password;
  final LoginStatus status;
}

class LoginInitial extends LoginState {
  const LoginInitial()
      : super(email: "", password: "", status: LoginStatus.notSubmitted);
}

class LoginSuccess extends LoginState {
  const LoginSuccess({
    required String email,
    required String password,
  }) : super(email: email, password: password, status: LoginStatus.success);

  LoginSuccess.from(LoginState s) : this(email: s.email, password: s.password);
}

class LoginFailure extends LoginState {
  const LoginFailure({
    required String email,
    required String password,
  }) : super(email: email, password: password, status: LoginStatus.failure);

  LoginFailure.from(LoginState s) : this(email: s.email, password: s.password);
}

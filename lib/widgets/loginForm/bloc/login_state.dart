part of 'login_bloc.dart';

enum LoginStatus {
  success,
  failure,
  notSubmitted,
}

@immutable
abstract class LoginState {
  const LoginState({
    required this.user,
    required this.status,
  });

  final User user;
  final LoginStatus status;
}

class LoginInitial extends LoginState {
  const LoginInitial()
      : super(
          user: const User(email: "", password: ""),
          status: LoginStatus.notSubmitted,
        );
}

class LoginSuccess extends LoginState {
  const LoginSuccess({required User user})
      : super(user: user, status: LoginStatus.success);

  LoginSuccess.from(LoginState s) : this(user: s.user);
}

class LoginFailure extends LoginState {
  const LoginFailure({required User user})
      : super(user: user, status: LoginStatus.failure);

  LoginFailure.from(LoginState s) : this(user: s.user);
}

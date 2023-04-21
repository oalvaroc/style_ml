part of 'login_bloc.dart';

enum LoginStatus {
  success,
  failure,
  notSubmitted,
}

@immutable
class LoginState {
  const LoginState({
    required this.isPasswordVisible,
    required this.email,
    required this.password,
    required this.status,
  });

  const LoginState.initial()
      : this(
          email: '',
          password: '',
          isPasswordVisible: false,
          status: LoginStatus.notSubmitted,
        );

  final bool isPasswordVisible;
  final String email;
  final String password;
  final LoginStatus status;

  LoginState copyWith({
    bool? isPasswordVisible,
    String? email,
    String? password,
    LoginStatus? status,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  bool get isComplete => email.isNotEmpty && password.isNotEmpty;
}

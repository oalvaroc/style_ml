import 'package:style_ml/models/user.dart';

abstract class AuthProvider {
  Stream<UserModel?> get stream;
  Future<void> createUser(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}

// errors
abstract class AuthProviderException implements Exception {
  String get message;
}

class WrongCredentialsException extends AuthProviderException {
  @override
  String get message => "Wrong credentials";
}

class InvalidEmailException extends AuthProviderException {
  @override
  String get message => "Invalid email";
}

class WeakPasswordException extends AuthProviderException {
  @override
  String get message => "Weak password";
}

class EmailAlreadyInUseException extends AuthProviderException {
  @override
  String get message => "Email already in use";
}

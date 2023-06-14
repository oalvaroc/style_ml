import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.email,
    required this.password,
  });

  User.fromMap(Map<String, dynamic> map)
      : this(
          email: map['email']!,
          password: map['password']!,
        );

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];

  Map<String, String> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

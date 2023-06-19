import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({required this.uid});

  UserModel.fromMap(Map<String, dynamic> map) : this(uid: map['uid']);

  final String uid;

  @override
  List<Object?> get props => [uid];

  Map<String, String> toMap() {
    return {
      'uid': uid,
    };
  }
}

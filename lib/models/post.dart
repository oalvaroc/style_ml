import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:style_ml/models/user.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.author,
    required this.image,
    required this.likes,
    this.published = false,
  });

  PostModel.fromMap(Map<String, dynamic> map)
      : this(
          author: UserModel.fromMap(map['author']),
          image: base64.decode(map['image'] as String),
          likes:
              (map['likes'] as List).map((u) => UserModel.fromMap(u)).toList(),
          published: map['published'],
        );

  final UserModel author;
  final Uint8List image;
  final List<UserModel> likes;
  final bool published;

  @override
  List<Object?> get props => [author, image, likes, published];

  Map<String, Object> toMap() {
    return {
      'author': author.toMap(),
      'image': base64.encode(image),
      'likes': likes.map((user) => user.toMap()).toList(),
      'published': published,
    };
  }

  PostModel copyWith({
    UserModel? author,
    Uint8List? image,
    List<UserModel>? likes,
    bool? published,
  }) {
    return PostModel(
      author: author ?? this.author,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      published: published ?? this.published,
    );
  }
}

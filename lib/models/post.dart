import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:style_ml/models/user.dart';

class Post extends Equatable {
  const Post({
    required this.image,
    required this.likes,
    this.published = false,
  });

  Post.fromMap(Map<String, dynamic> map)
      : this(
          image: base64.decode(map['image'] as String),
          likes: map['likes'],
          published: map['published'],
        );

  final Uint8List image;
  final List<User> likes;
  final bool published;

  @override
  List<Object?> get props => [image, likes, published];

  Map<String, Object> toMap() {
    return {
      'image': base64.encode(image),
      'likes': likes.map((user) => user.toMap()).toList(),
      'published': published,
    };
  }

  Post copyWith({
    Uint8List? image,
    List<User>? likes,
    bool? published,
  }) {
    return Post(
      image: image ?? this.image,
      likes: likes ?? this.likes,
      published: published ?? this.published,
    );
  }
}

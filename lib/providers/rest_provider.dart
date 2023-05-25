import 'dart:async';

import 'package:dio/dio.dart';
import 'package:style_ml/models/post_collection.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/models/user.dart';
import 'package:style_ml/providers/data_provider.dart';

class RestProvider implements DataProvider {
  static final helper = RestProvider._createInstance();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://stylemlbackend-production.up.railway.app'));
  StreamController? _controller;

  RestProvider._createInstance();

  Stream get stream {
    _controller ??= StreamController();
    return _controller!.stream;
  }

  void notify(String postId, Post? post) {
    _controller?.sink.add([postId, post]);
  }

  @override
  void insertPost(Post post) async {
    final res = await _dio.post('/posts', data: post.toMap());
    notify(res.data['id'], post);
  }

  @override
  void updatePost(String postId, Post post) {
    _dio.put('/posts/$postId', data: post.toMap());
    notify(postId, post);
  }

  @override
  void deletePost(String postId) {
    _dio.delete('/posts/$postId');
    notify(postId, null);
  }

  @override
  Future<PostCollection> fetchPosts() async {
    final res = await _dio.get('/posts');
    final posts = PostCollection();

    res.data.forEach((value) {
      posts.insert(
        value['id'],
        Post.fromMap({
          'image': value['image'],
          'likes': (value['likes'] as List)
              .map(
                (userData) => User.fromMap(
                  {
                    'name': userData['name'],
                    'email': userData['email'],
                    'password': userData['password'],
                  },
                ),
              )
              .toList(),
          'published': value['published'],
        }),
      );
    });

    return posts;
  }
}

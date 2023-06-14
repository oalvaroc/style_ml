import 'package:style_ml/models/post.dart';
import 'package:style_ml/models/post_collection.dart';

abstract class DataProvider {
  Stream<PostCollection> get stream;

  void insertPost(Post post);
  void updatePost(String postId, Post post);
  void deletePost(String postId);
  Future<PostCollection> fetchPosts();
}

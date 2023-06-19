import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:style_ml/models/post_collection.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/providers/data_provider.dart';

class FirestoreProvider implements DataProvider {
  final _postCollection = FirebaseFirestore.instance.collection('posts');

  @override
  Stream<PostCollection> get stream {
    return _postCollection
        .snapshots()
        .map((event) => _snapshotToCollection(event));
  }

  @override
  void insertPost(PostModel post) {
    _postCollection.add(post.toMap());
  }

  @override
  void updatePost(String postId, PostModel post) {
    _postCollection.doc(postId).update(post.toMap());
  }

  @override
  void deletePost(String postId) {
    _postCollection.doc(postId).delete();
  }

  @override
  Future<PostCollection> fetchPosts() async {
    final res = await _postCollection.get();
    return _snapshotToCollection(res);
  }

  PostCollection _snapshotToCollection(QuerySnapshot<Map<String, dynamic>> s) {
    final posts = PostCollection();
    for (final doc in s.docs) {
      final post = PostModel.fromMap(doc.data());
      posts.insert(doc.id, post);
    }
    return posts;
  }
}

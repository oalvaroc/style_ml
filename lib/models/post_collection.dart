import 'package:style_ml/models/post.dart';

class PostCollection {
  final List<String> _ids = [];
  final Map<String, Post> _posts = {};

  int get length {
    return _ids.length;
  }

  PostCollection get published {
    final collection = PostCollection();
    _posts.entries
        .where((element) => element.value.published == true)
        .forEach((element) => collection.insert(element.key, element.value));
    return collection;
  }

  void insert(String id, Post post) {
    _ids.add(id);
    _posts[id] = post;
  }

  void delete(String id) {
    final index = getIndexOfId(id);
    _ids.removeAt(index);
    _posts.remove(id);
  }

  void update(String id, Post post) {
    if (_posts.containsKey(id)) {
      _posts[id] = post;
    }
  }

  void updateOrInsert(String id, Post post) {
    if (_posts.containsKey(id)) {
      update(id, post);
    } else {
      insert(id, post);
    }
  }

  Post? getById(String id) {
    return _posts[id];
  }

  Post? getByIndex(int index) {
    if (index < _ids.length) {
      String id = _ids[index];
      return _posts[id];
    }
    return null;
  }

  String getIdOfIndex(int index) {
    return _ids[index];
  }

  int getIndexOfId(String id) {
    return _ids.indexOf(id);
  }
}

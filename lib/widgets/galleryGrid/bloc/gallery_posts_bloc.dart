import 'dart:collection';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:style_ml/widgets/styledImage/bloc/styled_image_bloc.dart';

part 'gallery_posts_event.dart';
part 'gallery_posts_state.dart';

class GalleryPostsBloc extends Bloc<GalleryPostsEvent, GalleryPostsState> {
  GalleryPostsBloc() : super(const GalleryPostsState.initial()) {
    on<GalleryPostsCreated>((event, emit) {
      final queue = Queue<Post>.from(state.posts);
      queue.addFirst(Post(id: _generateId(), image: event.image));

      final posts = queue.toList();
      emit(state.copyWith(posts: posts));
    });
    on<GalleryPostsDeleted>((event, emit) {
      final posts = state.posts.where((e) => e.id != event.id).toList();
      debugPrint('> $posts');
      emit(state.copyWith(posts: posts));
    });
    on<GalleryPostsStarted>((event, emit) async {
      final value = await rootBundle
          .load(StyleNames.blackAndViolet.path)
          .then((asset) => asset.buffer.asUint8List());
      final posts =
          List.generate(10, (index) => Post(id: _generateId(), image: value));
      emit(state.copyWith(posts: posts, isInit: true));
    });
  }

  static int _id = -1;

  int _generateId() {
    _id += 1;
    return _id;
  }
}

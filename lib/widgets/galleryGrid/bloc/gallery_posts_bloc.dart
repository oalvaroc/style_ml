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
      final posts = state.posts.followedBy([event.image]).toList();
      emit(state.copyWith(posts: posts));
    });
    on<GalleryPostsDeleted>((event, emit) {
      final posts =
          state.posts.where((e) => e != state.posts[event.id]).toList();
      emit(state.copyWith(posts: posts));
    });
    on<GalleryPostsStarted>((event, emit) async {
      final value = await rootBundle
          .load(StyleNames.blackAndViolet.path)
          .then((asset) => asset.buffer.asUint8List());
      final posts = List.filled(10, value);
      emit(state.copyWith(posts: posts, isInit: true));
    });
  }
}

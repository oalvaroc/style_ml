import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/models/post_collection.dart';
import 'package:style_ml/providers/rest_provider.dart';

class PostMonitorBloc extends Bloc<PostMonitorEvent, PostMonitorState> {
  PostMonitorBloc() : super(PostMonitorState(posts: PostCollection())) {
    RestProvider.helper.stream.listen((event) {
      String postId = event[0];
      Post? post = event[1];
      if (post != null) {
        state.posts.updateOrInsert(postId, post);
      } else {
        state.posts.delete(postId);
      }

      add(UpdatePostsEvent());
    });

    on<UpdatePostsEvent>((event, emit) {
      emit(PostMonitorState(posts: state.posts));
    });

    on<FetchPostsEvent>((event, emit) async {
      final posts = await RestProvider.helper.fetchPosts();
      emit(PostMonitorState(posts: posts));
    });
    add(FetchPostsEvent());
  }
}

// Events
class PostMonitorEvent {}

class FetchPostsEvent extends PostMonitorEvent {}

class UpdatePostsEvent extends PostMonitorEvent {}

// State
class PostMonitorState {
  PostMonitorState({required this.posts});

  final PostCollection posts;
}

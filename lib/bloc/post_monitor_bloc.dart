import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/models/post_collection.dart';
import 'package:style_ml/providers/rest_provider.dart';

class PostMonitorBloc extends Bloc<PostMonitorEvent, PostMonitorState> {
  PostMonitorBloc() : super(PostsReady(posts: PostCollection())) {
    RestProvider.helper.stream.listen((event) {
      if (state is! PostsReady) {
        return;
      }

      String postId = event[0];
      Post? post = event[1];

      if (post != null) {
        (state as PostsReady).posts.updateOrInsert(postId, post);
      } else {
        (state as PostsReady).posts.delete(postId);
      }

      add(UpdatePostsEvent());
    });

    on<UpdatePostsEvent>((event, emit) {
      if (state is PostsReady) {
        emit(PostsReady(posts: (state as PostsReady).posts));
      }
    });

    on<FetchPostsEvent>((event, emit) async {
      emit(PostsLoading());
      final posts = await RestProvider.helper.fetchPosts();
      print('fetched: ${posts.length}');
      emit(PostsReady(posts: posts));
    });

    add(FetchPostsEvent());
  }

  @override
  void onTransition(Transition<PostMonitorEvent, PostMonitorState> transition) {
    super.onTransition(transition);
    print('transition: $transition');
  }
}

// Events
class PostMonitorEvent {}

class FetchPostsEvent extends PostMonitorEvent {}

class UpdatePostsEvent extends PostMonitorEvent {}

// State
class PostMonitorState {}

class PostsLoading extends PostMonitorState {}

class PostsReady extends PostMonitorState {
  PostsReady({required this.posts});

  final PostCollection posts;
}

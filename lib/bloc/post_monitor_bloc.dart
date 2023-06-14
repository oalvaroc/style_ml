import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/models/post_collection.dart';
import 'package:style_ml/providers/data_provider.dart';

class PostMonitorBloc extends Bloc<PostMonitorEvent, PostMonitorState> {
  final DataProvider _provider;
  PostCollection _postCollection = PostCollection();

  PostMonitorBloc(this._provider) : super(PostsReady(posts: PostCollection())) {
    _provider.stream.listen((event) {
      if (state is! PostsReady) {
        return;
      }
      _postCollection = event;
      add(UpdatePostsEvent());
    });

    on<UpdatePostsEvent>((event, emit) {
      if (state is PostsReady) {
        emit(PostsReady(posts: _postCollection));
      }
    });

    on<FetchPostsEvent>((event, emit) async {
      emit(PostsLoading());
      final posts = await _provider.fetchPosts();
      emit(PostsReady(posts: posts));
    });

    add(FetchPostsEvent());
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

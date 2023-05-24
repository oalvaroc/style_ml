import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/providers/rest_provider.dart';

class PostManagerBloc extends Bloc<PostManagerEvent, PostManagerState> {
  PostManagerBloc() : super(PostManagerInitial()) {
    on<InsertEvent>((event, emit) {
      RestProvider.helper.insertPost(event.post);
    });
    on<UpdateEvent>((event, emit) {
      RestProvider.helper.updatePost(event.postId, event.post);
    });
    on<DeleteEvent>((event, emit) {
      RestProvider.helper.deletePost(event.postId);
    });
  }
}

// Events
class PostManagerEvent {}

class InsertEvent extends PostManagerEvent {
  InsertEvent({required this.post});

  final Post post;
}

class DeleteEvent extends PostManagerEvent {
  DeleteEvent({required this.postId});

  final String postId;
}

class UpdateEvent extends PostManagerEvent {
  UpdateEvent({required this.postId, required this.post});

  final String postId;
  final Post post;
}

// State
class PostManagerState {}

class PostManagerInitial extends PostManagerState {}

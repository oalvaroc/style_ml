import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/providers/data_provider.dart';

class PostManagerBloc extends Bloc<PostManagerEvent, PostManagerState> {
  final DataProvider _provider;

  PostManagerBloc(this._provider) : super(InitialState()) {
    on<CreateEvent>((event, emit) {
      emit(CreateState(contentImage: event.contentImage));
    });
    on<InsertEvent>((event, emit) {
      _provider.insertPost(event.post);
      emit(InitialState());
    });
    on<UpdateEvent>((event, emit) {
      _provider.updatePost(event.postId, event.post);
      emit(InitialState());
    });
    on<DeleteEvent>((event, emit) {
      _provider.deletePost(event.postId);
      emit(InitialState());
    });
  }
}

// Events
class PostManagerEvent {}

class CreateEvent extends PostManagerEvent {
  CreateEvent({required this.contentImage});

  final Uint8List contentImage;
}

class InsertEvent extends PostManagerEvent {
  InsertEvent({required this.post});

  final PostModel post;
}

class DeleteEvent extends PostManagerEvent {
  DeleteEvent({required this.postId});

  final String postId;
}

class UpdateEvent extends PostManagerEvent {
  UpdateEvent({required this.postId, required this.post});

  final String postId;
  final PostModel post;
}

// State
class PostManagerState {}

class InitialState extends PostManagerState {}

class CreateState extends PostManagerState {
  CreateState({required this.contentImage});

  final Uint8List contentImage;
}

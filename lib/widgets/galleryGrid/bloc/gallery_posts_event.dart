part of 'gallery_posts_bloc.dart';

@immutable
abstract class GalleryPostsEvent {}

class GalleryPostsCreated extends GalleryPostsEvent {
  GalleryPostsCreated({required this.image});

  final Uint8List image;
}

class GalleryPostsDeleted extends GalleryPostsEvent {
  GalleryPostsDeleted({required this.id});

  final int id;
}

// TODO: remove this event when backend integration is implemented
class GalleryPostsStarted extends GalleryPostsEvent {}

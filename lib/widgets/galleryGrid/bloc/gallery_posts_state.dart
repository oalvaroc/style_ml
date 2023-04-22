part of 'gallery_posts_bloc.dart';

@immutable
class GalleryPostsState {
  const GalleryPostsState({required this.posts, this.isInit = false});

  const GalleryPostsState.initial() : this(posts: const []);

  final List<Uint8List> posts;

  // TODO: remove this event when backend integration is implemented
  final bool isInit;

  GalleryPostsState copyWith({
    List<Uint8List>? posts,
    bool? isInit,
  }) {
    return GalleryPostsState(
      posts: posts ?? this.posts,
      isInit: isInit ?? this.isInit,
    );
  }
}

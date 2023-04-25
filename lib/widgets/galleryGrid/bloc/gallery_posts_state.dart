part of 'gallery_posts_bloc.dart';

@immutable
class GalleryPostsState {
  const GalleryPostsState({required this.posts, this.isInit = false});

  const GalleryPostsState.initial() : this(posts: const []);

  final List<Post> posts;

  // TODO: remove this event when backend integration is implemented
  final bool isInit;

  GalleryPostsState copyWith({
    List<Post>? posts,
    bool? isInit,
  }) {
    return GalleryPostsState(
      posts: posts ?? this.posts,
      isInit: isInit ?? this.isInit,
    );
  }
}

@immutable
class Post {
  const Post({required this.image, required this.id});

  final Uint8List image;
  final int id;
}

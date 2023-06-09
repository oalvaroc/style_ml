import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/auth_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/bloc/post_monitor_bloc.dart';
import 'package:style_ml/models/user.dart';

class DiscoverGrid extends StatefulWidget {
  const DiscoverGrid({super.key});

  @override
  State<DiscoverGrid> createState() => _DiscoverGridState();
}

class _DiscoverGridState extends State<DiscoverGrid> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = BlocProvider.of<PostMonitorBloc>(context)
          ..add(FetchPostsEvent());
        await bloc.stream.firstWhere((element) => element is PostsReady);
      },
      child: BlocBuilder<PostMonitorBloc, PostMonitorState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final publishedPosts = (state as PostsReady).posts.published;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: publishedPosts.length,
            itemBuilder: (context, index) {
              final post = publishedPosts.getByIndex(index)!;
              final postId = publishedPosts.getIdOfIndex(index);

              return Stack(
                fit: StackFit.passthrough,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Material(
                      child: Ink.image(
                        image: MemoryImage(post.image),
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Stack(
                                    children: [
                                      Image.memory(post.image),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(Icons.close),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                const CircleBorder()),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white54,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Column(
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return IconButton(
                              onPressed: () {
                                List<UserModel> likes = [];

                                if (post.likes.contains(state.user)) {
                                  likes = post.likes
                                      .where((user) => user != state.user)
                                      .toList();
                                } else {
                                  likes = post.likes
                                      .followedBy([state.user]).toList();
                                }
                                BlocProvider.of<PostManagerBloc>(context).add(
                                  UpdateEvent(
                                    postId: postId,
                                    post: post.copyWith(likes: likes),
                                  ),
                                );
                              },
                              isSelected: post.likes
                                  .contains((state as Authenticated).user),
                              icon: const Icon(Icons.thumb_up),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white38,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

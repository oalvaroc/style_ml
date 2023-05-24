import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/bloc/post_monitor_bloc.dart';
import 'package:style_ml/models/post.dart';
import 'package:style_ml/models/user.dart';
import 'package:style_ml/widgets/loginForm/bloc/login_bloc.dart';

class DiscoverGrid extends StatefulWidget {
  const DiscoverGrid({super.key});

  @override
  State<DiscoverGrid> createState() => _DiscoverGridState();
}

class _DiscoverGridState extends State<DiscoverGrid> {
  final Set<int> _likedPosts = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostMonitorBloc, PostMonitorState>(
      builder: (context, state) {
        final publishedPosts = state.posts.published;

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
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return IconButton(
                            onPressed: () {
                              List<User> likes = [];

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
                            isSelected: post.likes.contains(state.user),
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
    );
  }
}

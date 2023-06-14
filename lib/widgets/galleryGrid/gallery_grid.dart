import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:style_ml/bloc/post_manager_bloc.dart';
import 'package:style_ml/bloc/post_monitor_bloc.dart';

class GalleryGrid extends StatefulWidget {
  const GalleryGrid({super.key});

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
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

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: (state as PostsReady).posts.length,
            itemBuilder: (context, index) {
              final post = state.posts.getByIndex(index)!;
              final postId = state.posts.getIdOfIndex(index);

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
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete'),
                              content: const SingleChildScrollView(
                                child: Text(
                                  'Are you sure you want to delete this image?',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    BlocProvider.of<PostManagerBloc>(context)
                                        .add(DeleteEvent(postId: postId));

                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Post deleted'),
                                        showCloseIcon: true,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white38,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        BlocProvider.of<PostManagerBloc>(context).add(
                          UpdateEvent(
                            postId: postId,
                            post: post.copyWith(published: !post.published),
                          ),
                        );
                      },
                      icon: const Icon(Icons.public),
                      isSelected: post.published,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(const CircleBorder()),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.white38,
                        ),
                      ),
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

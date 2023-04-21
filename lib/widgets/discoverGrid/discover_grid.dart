import 'package:flutter/material.dart';

class DiscoverGrid extends StatefulWidget {
  const DiscoverGrid({super.key});

  @override
  State<DiscoverGrid> createState() => _DiscoverGridState();
}

class _DiscoverGridState extends State<DiscoverGrid> {
  final Set<int> _likedPosts = {};

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/van-gogh-starry-night.jpg'),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_likedPosts.lookup(index) == null) {
                        setState(() {
                          _likedPosts.add(index);
                        });
                      } else {
                        setState(() {
                          _likedPosts.remove(index);
                        });
                      }
                    },
                    isSelected: _likedPosts.lookup(index) != null,
                    icon: const Icon(Icons.thumb_up),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(const CircleBorder()),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

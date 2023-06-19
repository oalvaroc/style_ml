import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:style_ml/bloc/auth_bloc.dart';

import '../widgets/discoverGrid/discover_grid.dart';
import '../widgets/galleryGrid/gallery_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final _box = Hive.box('login');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/about');
            },
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPage,
        children: const [
          Padding(
            padding: EdgeInsets.all(10),
            child: DiscoverGrid(),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: GalleryGrid(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            label: 'Discover',
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: 'Gallery',
            icon: Icon(Icons.person),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/camera');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

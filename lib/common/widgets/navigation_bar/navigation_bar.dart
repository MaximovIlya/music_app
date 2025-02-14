import 'package:flutter/material.dart';
import 'package:music_app/presentation/favorites/favorites_page.dart';
import 'package:music_app/presentation/home/pages/home.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int currentPage = 0;

  final List<Widget> pages = const [
    HomePage(),
    FavoritesPage(),
  ];

  @override
  void initState() {
    currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Container(
            height: 1, 
            color: const Color.fromARGB(255, 45, 45, 45), 
          ),
          BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 84, 84, 84),
            iconSize: 35,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: (value) {
              setState(() {
                currentPage = value;
              });
            },
            currentIndex: currentPage,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.music_note_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

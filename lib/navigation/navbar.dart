import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:media/Screens/music.dart';
import 'package:media/Screens/video.dart';

class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  final List<Widget> pages = [
    const Music(),
    const LocalVideoPlayer(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Media Player',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: pages[currentPage],
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 11, 17, 70),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GNav(
              backgroundColor: const Color.fromARGB(255, 59, 40, 128),
              gap: 8,
              activeColor: Colors.white,
              color: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              duration: const Duration(milliseconds: 800),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconSize: 30.0,
                ),
                GButton(
                  // key: Key('profile'),
                  icon: Icons.people,
                  iconSize: 30.0,
                ),
              ],
              selectedIndex: currentPage,
              onTabChange: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

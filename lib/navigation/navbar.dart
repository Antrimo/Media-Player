import 'package:app1/Screens/music.dart';
import 'package:app1/Screens/video.dart';
import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';


class Nav extends StatefulWidget {
  const Nav({super.key});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  final List<Widget> pages = [
    const LocalMusicPlayer(),
    const LocalVideoPlayer(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: const Center(
            child: Text(       
              'Media Player',
              style: TextStyle(color: Colors.white,fontFamily: "Cursive",),
            ),
          ),
        ),
        body: pages[currentPage],
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 59, 40, 128),
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

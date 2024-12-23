import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/library_page.dart';
import 'package:client/features/home/view/songs_page.dart';
import 'package:client/features/home/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final List<Widget> _pages = const [SongsPage(), LibraryPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[selectedIndex],
          Positioned(
            bottom: 0,
            child: MusicSlab(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_unfilled.png',
              color: selectedIndex == 0 ? Pallete.whiteColor : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
            activeIcon: Image.asset('assets/images/home_filled.png'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: selectedIndex == 1 ? Pallete.whiteColor : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}

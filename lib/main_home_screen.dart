import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/swap_without_key_screen.dart';
import 'screens/swap_with_key_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final ValueNotifier<Color> backgroundColorNotifier = ValueNotifier<Color>(Colors.white);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    backgroundColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      HomeScreen(backgroundColorNotifier: backgroundColorNotifier),
      const SearchScreen(),
      SettingsScreen(backgroundColorNotifier: backgroundColorNotifier),
      const SwapWithoutKeyScreen(),
      const SwapWithKeyScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noted'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Swap'),
          BottomNavigationBarItem(icon: Icon(Icons.vpn_key), label: 'Swap w/ Key')
          
        ],
      ),
    );
  }
}
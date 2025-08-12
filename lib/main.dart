import 'package:flutter/material.dart';
import 'package:lesson1/lessons/screens/factorial_screen.dart';
import 'package:lesson1/lessons/screens/hello_screen.dart';
import 'package:lesson1/lessons/screens/async_call_screen.dart';
import 'package:lesson1/lessons/screens/counter_screen.dart';
import 'package:lesson1/lessons/screens/counter_keep_value_screen.dart';

void main() {
  runApp(const MyProjectsApp());
}

class MyProjectsApp extends StatefulWidget {
  const MyProjectsApp({super.key});

  @override
  State<MyProjectsApp> createState() => _MyProjectsAppState();
}

class _MyProjectsAppState extends State<MyProjectsApp> {
  int _selectedIndex = 0;
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);

  // Screen created once (state preserved)
  late final List<Widget> _screens = [
    MenuScreen(onSelectScreen: _onItemTapped),
    Hello(message: "Hello Flutter World!", onBack: () => _onItemTapped(0)),
    FactorialHome(onBack: () => _onItemTapped(0)),
    AsyncScreen(onBack: () => _onItemTapped(0)),
    CounterScreen(onBack: () => _onItemTapped(0)),
    Counter(onBack: () => _onItemTapped(0))
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        )
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final void Function(int) onSelectScreen;
  const MenuScreen({super.key, required this.onSelectScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Hello World'),
              onPressed: () => onSelectScreen(1),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Factorial'),
              onPressed: () => onSelectScreen(2),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Async Call (Simulate a network call)'),
              onPressed: () => onSelectScreen(3),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Counter (Reset Count)'),
              onPressed: () => onSelectScreen(4),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Counter (Save Count)'),
              onPressed: () => onSelectScreen(5),
            ),
          ],
        ),
      ),
    );
  }
}


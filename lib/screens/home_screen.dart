import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final ValueNotifier<Color> backgroundColorNotifier;

  const HomeScreen({Key? key, required this.backgroundColorNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: backgroundColorNotifier,
      builder: (context, color, child) {
        return Container(
          color: color,
          child: const Center(
            child: Text(
              'Home Screen',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }
}

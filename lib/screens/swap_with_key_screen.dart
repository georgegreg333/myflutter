import 'package:flutter/material.dart';

class SwapWithKeyScreen extends StatefulWidget {
  const SwapWithKeyScreen({Key? key}) : super(key: key);

  @override
  State<SwapWithKeyScreen> createState() => _SwapWithKeyScreenState();
}

class _SwapWithKeyScreenState extends State<SwapWithKeyScreen> {
  bool _reversed = false;

  @override
  Widget build(BuildContext context) {
    final boxes = _reversed
        ? [
            ColoredBoxWithKey(key: const ValueKey('A'), color: Colors.lightBlue, label: 'Box A'),
            ColoredBoxWithKey(key: const ValueKey('B'), color: Colors.green, label: 'Box B'),
          ]
        : [
            ColoredBoxWithKey(key: const ValueKey('B'), color: Colors.green, label: 'Box B'),
            ColoredBoxWithKey(key: const ValueKey('A'), color: Colors.lightBlue, label: 'Box A'),
          ];

    return Scaffold(
      appBar: AppBar(title: const Text('Swap Boxes With Key')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _reversed = !_reversed;
                });
              },
              child: const Text('Swap Boxes'),
            ),
            const SizedBox(height: 20),
            ...boxes,
          ],
        ),
      ),
    );
  }
}

class ColoredBoxWithKey extends StatefulWidget {
  final Color color;
  final String label;

  const ColoredBoxWithKey({
    required Key key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  State<ColoredBoxWithKey> createState() => _ColoredBoxWithKeyState();
}

class _ColoredBoxWithKeyState extends State<ColoredBoxWithKey> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          padding: const EdgeInsets.all(24),
        ),
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        child: Text('${widget.label}: $_counter', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SwapWithoutKeyScreen extends StatefulWidget {
  const SwapWithoutKeyScreen({Key? key}) : super(key: key);

  @override
  State<SwapWithoutKeyScreen> createState() => _SwapWithoutKeyScreenState();
}

class _SwapWithoutKeyScreenState extends State<SwapWithoutKeyScreen> {
  bool _reversed = false;

  @override
  Widget build(BuildContext context) {
    final boxes = _reversed
        ? [
            const ColoredBoxWithoutKey(color: Colors.lightBlue, label: 'Box A'),
            const ColoredBoxWithoutKey(color: Colors.green, label: 'Box B'),
          ]
        : [
            const ColoredBoxWithoutKey(color: Colors.green, label: 'Box B'),
            const ColoredBoxWithoutKey(color: Colors.lightBlue, label: 'Box A'),
          ];

    return Scaffold(
      appBar: AppBar(title: const Text('Swap Boxes Without Key')),
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

class ColoredBoxWithoutKey extends StatefulWidget {
  final Color color;
  final String label;

  const ColoredBoxWithoutKey({
    required this.color,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  State<ColoredBoxWithoutKey> createState() => _ColoredBoxWithoutKeyState();
}

class _ColoredBoxWithoutKeyState extends State<ColoredBoxWithoutKey> {
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
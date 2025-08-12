import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const CounterScreen({super.key, required this.onBack});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;

  void _increment() => setState(() => count++);
  void _decrement() => setState(() => count--);

  // Reset the counter to 0
  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter plus/minus (Reset Count)'),
        leading: IconButton(
          onPressed: () {
            reset();
            widget.onBack!();
          },
          icon: const Icon(Icons.arrow_back)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reset,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Count: $count', 
          style: TextStyle(fontSize: 28, color: count<0 ? Colors.red : Colors.blue),
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add)
          ),
          const SizedBox(height: 20),
          FloatingActionButton(
            onPressed: _decrement,
            child: const Icon(Icons.remove),
          ),
        ]
      ),
    );
  }
}
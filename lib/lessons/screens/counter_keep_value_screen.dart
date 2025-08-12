import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final VoidCallback? onBack;
  const Counter({super.key, this.onBack});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> with AutomaticKeepAliveClientMixin{
  int counter = 0;

  void _increment() => setState(() {counter++;});
  void _decrement() => setState(() {counter--;});

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter (Saving Count Number with AutomaticKeepAliveClientMixin)'), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () {},
        ),
      ),
      body: Center(
        child: Text(
          'Count $counter',
          style: TextStyle(fontSize: 28, color: counter<0 ? Colors.red : Colors.blue)
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _decrement,
            child: const Icon(Icons.remove)
          )
        ],
      ),
    );
  }
}
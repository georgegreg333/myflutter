import 'package:flutter/material.dart';
import 'package:lesson1/lessons/logic/factorial.dart';

class FactorialHome extends StatefulWidget {
  final VoidCallback? onBack;
  const FactorialHome({super.key, required this.onBack});

  @override
  State<FactorialHome> createState() => _FactorialHomeState();
}

class _FactorialHomeState extends State<FactorialHome> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _result = calcFactorialfromInput(_controller.text);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Factorial Calculator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop()
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Calculating the Factorial number <= 20!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter a number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _result,
              style: TextStyle(fontSize: 20, color: _result.startsWith('Factorial') ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
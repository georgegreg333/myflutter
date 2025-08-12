import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lesson1/lessons/logic/async_call.dart';

class AsyncScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const AsyncScreen({super.key, required this.onBack});

  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen> {
  String _message = 'Press the button to fetch data';

  Future<void> _fetchData() async {
    setState(() {
      _message = 'Loading...';
    });

    try {
      String result = await fakeFetch()
          .timeout(const Duration(seconds: 3)); // handle timeout
      setState(() {
        _message = result;
      });
    } on TimeoutException {
      setState(() {
        _message = 'Error: Request timed out';
      });
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Network Simulation'),
        leading: IconButton(
          onPressed: widget.onBack ?? () {},
          icon: const Icon(Icons.arrow_back)
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Data'),
            ),
          ],
        ),
      ),
    );
  }
}

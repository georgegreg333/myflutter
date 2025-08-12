import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
  final String message;
  final VoidCallback? onBack;

  const Hello({super.key, required this.message, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Hello Screen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack ?? () => Navigator.of(context).pop()
        ),
      ),
      body: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

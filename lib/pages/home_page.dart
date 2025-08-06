import 'package:flutter/material.dart';
import 'second_page.dart'; // Import the second page
import 'users.dart'; // Import users page

// Main home page of the app, stateful so it can manage and update state like the counter
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Title shown in the AppBar

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Counter to track button taps

  // Increments the counter and triggers a rebuild
  void _incrementCounter() => setState(() => _counter++);
  // Decrements the counter and triggers a rebuild
  void _decrementCounter() => setState(() => _counter--);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)), // Display the page title in the AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center children
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 30),
            // Button to navigate to the SecondPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondPage()),
                );
              },
              child: const Text("Go to Second Page"),
            ),
            // Button to navigate to the UsersPage
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersPage()),
                );
              },
              child: const Text("Go to Report Waste Disposal Page"),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(onPressed: _incrementCounter, child: const Icon(Icons.add)),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _decrementCounter,
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'second_page.dart'; // Import the second page
import 'users.dart'; // Import users page
import 'image_upload.dart';

// Main home page of the app, stateful so it can manage and update state like the counter
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; // Title shown in the AppBar

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State class for MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)), // Display the page title in the AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center children
          children: <Widget>[
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageUploadPage(),
                  ),
                );
              },
              child: const Text('Go to Image Upload Page'),
            ),
          ],
        ),
      ),
    );
  }
}

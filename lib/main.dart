import 'package:flutter/material.dart'; // Import the Flutter material design package
import 'pages/home_page.dart'; // Import the home page file
//import 'package:wastespotter/pages/api_service.dart';
//import 'pages/users.dart'; // Import the custom UsersPage widget from the 'pages' directory

// Entry point of the Flutter app
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'My Home Page'), // Set home page
    );
  }
}

//void main() => runApp(MaterialApp(home: UsersPage())); // Set UsersPage as the first screen (home) of the app
import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Import the home page file
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform; // Import for checking desktop platforms
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Only initialize window_manager on desktop platforms (not web, Android, or iOS)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await windowManager.ensureInitialized();

    WindowOptions options = const WindowOptions(
      size: Size(800, 600),
      center: true, // Automatically center the window on launch
      title: "WasteSpotter",
    );

    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WasteSpotter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'My Home Page'), // Set home page
    );
  }
}

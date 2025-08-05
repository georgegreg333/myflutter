import 'package:flutter/material.dart';
import '../screens/users_page.dart';
import '../screens/user_form_page.dart';
import '../screens/user_update_form_page.dart';
import '../screens/activity_form_page.dart';
import '../screens/user_activities_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    //await windowManager.setFullScreen(true); // Launch in fullscreen
    await windowManager.maximize(); // Maximize window
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICommute',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const UsersPage());

          case '/create':
            return MaterialPageRoute(builder: (_) => UserFormPage());

          case '/update':
            final user = settings.arguments;
            if (user == null) {
              return MaterialPageRoute(builder: (_) => const UsersPage());
            }
            return MaterialPageRoute(
              builder: (_) => const UserUpdateFormPage(),
              settings: settings, // this keeps the arguments accessible via ModalRoute
            );

          case '/activity_form':
            final userId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ActivityFormPage(userId: userId),
              settings: settings,
            );

          case '/user_activities':
            final userId = settings.arguments as int?;
            if (userId == null) {
              return MaterialPageRoute(builder: (_) => const UsersPage());
            }
            return MaterialPageRoute(
              builder: (_) => UserActivitiesPage(userId: userId),
              settings: settings,
            );
            
          default:
            // Unknown route fallback
            return MaterialPageRoute(builder: (_) => const UsersPage());
        }
      },
    );
  }
}

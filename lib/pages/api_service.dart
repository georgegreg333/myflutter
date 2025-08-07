import 'dart:convert'; // For converting JSON to Dart objects and vice versa
import 'package:http/http.dart' as http; // HTTP package for making API requests
import 'dart:io' show Platform;

// Service class to handle all API interactions
class ApiService {
  // Base URL of your backend API
  //static const String baseUrl = 'http://localhost:5151'; // Your API base URL
  //static const String baseUrl = 'http://10.0.2.2:5151';
  static String get baseUrl {
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:5151'; // Android emulator
  } else {
    return 'http://localhost:5151'; // Windows, macOS, etc.
  }
}


  // Fetch a list of all users from the backend
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/User')); // GET request to /User endpoint

    if (response.statusCode == 200) {
      // If successful, decode the JSON response into a Dart List
      // JSON (JavaScript Object Notation) is a lightweight, text-based format 
      // used for exchanging data between a server and a client (e.g., your Flutter app).
      // If your Flutter app needs to fetch a list of users from an API, 
      // the server would likely send a JSON response, which the Flutter app would decode into Dart objects. 
      // This allows the app to interact with structured data in an easy-to-manipulate format.
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  // Fetch a user by ID
  static Future<Map<String, dynamic>> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/User/$id'));
    print('GET $baseUrl/User/$id');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('REport not found');
    }
  }

  // Insert a new user
  static Future<void> insertUser(String name) async {
    final response = await http.post(
      Uri.parse('$baseUrl/User'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );
    print('POST $baseUrl/User');

    if (response.statusCode != 201) {
      throw Exception('Failed to add report');
    }
  }

  // Delete a user by ID
  static Future<bool> deleteUser(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/User/$id'),
    );

    if (response.statusCode == 200) {
      return true; // Successfully deleted
    } else {
      throw Exception('Failed to delete report');
    }
  }
}

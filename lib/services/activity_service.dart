import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity.dart';

class ActivityService {
  final String baseUrl = 'https://localhost:7073';
  //final String baseUrl = 'https://10.0.2.2:7073'; // Android emulator

  // Get all activities
  Future<List<Activity>> fetchActivities() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<List<Activity>> fetchUserActivities(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/activities/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  // Get a single activity by ID
  Future<Activity> fetchActivityById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch activity with id $id');
    }
  }

    // Create new activity
    Future<bool> createActivity(Activity activity) async {
      final response = await http.post(
        Uri.parse('$baseUrl/api/activities'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(activity.toJson()),
      );
      
      return response.statusCode == 200 || response.statusCode == 201;
    }

  // Update existing activity
  Future<Activity> updateActivity(Activity activity) async {
    final url = Uri.parse('$baseUrl/${activity.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode == 204) {
      return activity;
    } else {
      throw Exception('Failed to update activity: ${response.body}');
    }
  }

  // Delete activity
  Future<void> deleteActivity(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete activity');
    }
  }

  Future<Map<String, double>> fetchUserActivityTotals(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/activities/user/$userId/totals'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'totalMoneySaved': (data['totalMoneySaved'] as num).toDouble(),
        'totalProfit': (data['totalProfit'] as num).toDouble(),
      };
    } else {
      throw Exception('Failed to load activity totals');
    }
  }
}
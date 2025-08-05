import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';
import '../services/gpx_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<User>> _futureUsers;
  final _gpxService = GpxService();

  Future<void> _importGpxFile(BuildContext context, int userId) async {
    final messenger = ScaffoldMessenger.of(context); // Capture before async
    final navigator = Navigator.of(context); // Capture before async

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gpx'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = File(result.files.single.path!);

    try {
      final summary = await _gpxService.parseGpxFile(file);

      final double distance = summary.distanceKm;
      final int durationMinutes = summary.duration.inMinutes.toInt();
      final String type = summary.type;

      final int calories = (distance * 60).toInt();
      final int co2 = (distance * 120).toInt();
      final double moneySaved = distance * 0.15;
      final int trees = (distance / 100).toInt();
      int points = ((distance * 10) + (durationMinutes / 10)).toInt();
      if (type.toLowerCase() == 'cycling') points = (points * 1.2).toInt();
      final double profit = distance * 0.5;

      final activity = Activity(
        userId: userId,
        name: summary.name,
        type: type,
        distance: distance,
        time: durationMinutes,
        calories: calories,
        co2: co2,
        moneySaved: moneySaved,
        trees: trees,
        points: points,
        profit: profit,
      );

      print('Creating activity...');
      final bool success = await ActivityService().createActivity(activity);
      print('Activity creation success: $success');

      if (!mounted) return;

      if (success) {
        print('GPX Import successful, showing dialog...');
        await showDialog(
          context: navigator.context, // ← Use captured navigator context
          builder: (_) => AlertDialog(
            title: const Text('Activity Imported Successfully'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${summary.name}'),
                Text('Distance: ${distance.toStringAsFixed(2)} km'),
                Text('Duration: $durationMinutes minutes'),
                Text('Type: $type'),
                Text('Calories: $calories kcal'),
                Text('CO₂ Saved: $co2 g'),
                Text('Money Saved: €${moneySaved.toStringAsFixed(2)}'),
                Text('Trees Saved: $trees'),
                Text('Points Earned: $points'),
                Text('Profit Earned: €${profit.toStringAsFixed(2)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => navigator.pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        _refresh();
      } else {
        messenger.showSnackBar(
          const SnackBar(content: Text('Failed to save activity')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Error importing GPX: $e')),
      );
    }
  }

  void _showAddActivityOptions(BuildContext context, int userId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Add Activity Manually'),
              onTap: () async {
                Navigator.pop(context); // Close sheet
                final result = await Navigator.pushNamed(
                  context,
                  '/activity_form',
                  arguments: userId,
                );
                if (result == true) _refresh();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Import from GPX'),
              onTap: () async {
                Navigator.pop(context); // Close sheet
                await _importGpxFile(context, userId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _futureUsers = UserService().fetchUsers();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.firstname.isNotEmpty ? user.firstname[0] : '?'),
                    ),
                    title: Text('${user.firstname} ${user.lastname}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Money Saved: \$${(user.totalMoneySaved ?? 0).toStringAsFixed(2)}'),
                        Text('Total Profit Earned: \$${(user.totalProfit ?? 0).toStringAsFixed(2)}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.fitness_center),
                          tooltip: 'Add Activity',
                          onPressed: () => _showAddActivityOptions(context, user.id!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.list_alt),
                          tooltip: 'View Activities',
                          onPressed: () {
                            if (user.id == null || user.id == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User ID is missing. Cannot view activities.'),
                                ),
                              );
                              return;
                            }
                            Navigator.pushNamed(
                              context,
                              '/user_activities',
                              arguments: user.id,
                            );
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.of(context).pushNamed(
                        '/update',
                        arguments: user,
                      );
                      if (result == true) {
                        _refresh();
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create User',
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/create');
          if (result == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

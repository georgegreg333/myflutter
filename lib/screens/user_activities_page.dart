import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class UserActivitiesPage extends StatefulWidget {
  final int userId;

  const UserActivitiesPage({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _UserActivitiesPageState createState() => _UserActivitiesPageState();
}

class _UserActivitiesPageState extends State<UserActivitiesPage> {
  late Future<List<Activity>> _futureActivities;
  double? _totalMoneySaved;
  double? _totalProfit;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  void _loadActivities() {
    _futureActivities = ActivityService().fetchUserActivities(widget.userId);

    // Fetch totals
    ActivityService().fetchUserActivityTotals(widget.userId).then((totals) {
      setState(() {
        _totalMoneySaved = totals['totalMoneySaved'];
        _totalProfit = totals['totalProfit'];
      });
    }).catchError((e) {
      print('Error fetching totals: $e');
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activities')),
      body: FutureBuilder<List<Activity>>(
        future: _futureActivities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found.'));
          }

          final activities = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_totalMoneySaved != null && _totalProfit != null)
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Summary',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            'Total Money Saved: \$${_totalMoneySaved!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Total Profit: \$${_totalProfit!.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Removed Import from GPX button here
                ...activities.map((activity) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _buildRow(Icons.category, 'Type', activity.type),
                            _buildRow(Icons.place, 'Distance',
                                '${activity.distance.toStringAsFixed(2)} km'),
                            _buildRow(Icons.timer, 'Duration',
                                '${activity.time} min'),
                            if (activity.calories != null)
                              _buildRow(Icons.local_fire_department, 'Calories',
                                  '${activity.calories} kcal'),
                            if (activity.co2 != null)
                              _buildRow(Icons.eco, 'CO₂ Saved',
                                  '${activity.co2} g'),
                            if (activity.moneySaved != null)
                              _buildRow(Icons.savings, 'Money Saved',
                                  '\$${activity.moneySaved!.toStringAsFixed(2)}'),
                            if (activity.trees != null)
                              _buildRow(Icons.nature, 'Trees Saved',
                                  '${activity.trees}'),
                            if (activity.points != null)
                              _buildRow(Icons.star, 'Points Earned',
                                  '${activity.points}'),
                            if (activity.profit != null)
                              _buildRow(Icons.attach_money, 'Profit Earned',
                                  '\$${activity.profit!.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
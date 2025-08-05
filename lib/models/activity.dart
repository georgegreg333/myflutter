class Activity {
  final int? id;
  final String name;
  final double distance;
  final int time;
  final String type;
  final int? calories;
  final int? co2;
  final double? moneySaved;
  final int? trees;
  final int? points;
  final double? profit;
  final int? userId;

  Activity({
    this.id,
    required this.name,
    required this.distance,
    required this.time,
    required this.type,
    this.calories,
    this.co2,
    this.moneySaved,
    this.trees,
    this.points,
    this.profit,
    this.userId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      distance: (json['distance'] as num).toDouble(),
      time: json['time'],
      type: json['type'],
      calories: json['calories'],
      co2: (json['co2'] as num).toInt(),
      moneySaved: (json['moneySaved'] as num).toDouble(),
      trees: json['trees'],
      points: json['points'],
      profit: (json['profit'] as num).toDouble(),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'userId': userId,
      'distance': distance,
      'time': time,
      'type': type,
    };

    // Only add fields if they're not null
    if (id != null) data['id'] = id;
    if (calories != null) data['calories'] = calories;
    if (co2 != null) data['co2'] = co2;
    if (moneySaved != null) data['moneySaved'] = moneySaved;
    if (trees != null) data['trees'] = trees;
    if (points != null) data['points'] = points;
    if (profit != null) data['profit'] = profit;

    return data;
  }
}
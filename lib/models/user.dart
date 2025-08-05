class User {
  final int? id;
  final String firstname;
  final String lastname;
  final double? totalProfit;
  final double? totalMoneySaved;
  final int? age;
  final String? address;
  final String? email;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
    this.totalProfit,
    this.totalMoneySaved,
    this.age,
    this.address,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      totalProfit: (json['tprofit'] as num?)?.toDouble() ?? 0.0,
      totalMoneySaved: (json['tmoney'] as num?)?.toDouble() ?? 0.0,
      age: json['age'],
      address: json['address'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'tprofit': totalProfit ?? 0.0,
        'tmoney': totalMoneySaved ?? 0.0,
        'age': age,
        'address': address,
        'email': email,
      };
}
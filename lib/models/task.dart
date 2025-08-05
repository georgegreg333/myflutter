class Task {
  int? id;
  final String title;
  bool isDone;

  Task({
    this.id,
    required this.title,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,  // store as INTEGER in SQLite
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      isDone: map['isDone'] == 1,
    );
  }
}

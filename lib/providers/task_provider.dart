import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database/task_database.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  // Expose tasks as an unmodifiable list to prevent external modification
  List<Task> get tasks => List.unmodifiable(_tasks);

  // Load all tasks from the database
  Future<void> loadTasks() async {
    final tasksFromDb = await TaskDatabase.instance.readAllTasks();
    _tasks
      ..clear()
      ..addAll(tasksFromDb);
    notifyListeners();
  }

  // Add a new task to the database and update the local list
  Future<void> addTask(Task task) async {
    final newTask = await TaskDatabase.instance.create(task);
    _tasks.add(newTask);
    notifyListeners();
  }

  // Toggle the isDone status and update in DB
  Future<void> toggleTaskStatus(Task task) async {
    task.isDone = !task.isDone;
    await TaskDatabase.instance.update(task);
    // Update local list by replacing the old task (optional, depending on your Task model equality)
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  // Remove a task by id from DB and local list
  Future<void> removeTask(int id) async {
    await TaskDatabase.instance.delete(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

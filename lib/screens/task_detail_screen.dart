import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  TaskDetailScreen({required this.taskId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    Task? task;

    try {
      task = taskProvider.tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      task = null;
    }

    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Task Not Found'),
        ),
        body: Center(
          child: Text('No task found for ID: $taskId'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Task ID: ${task.id}\n\nStatus: ${task.isDone ? "Completed" : "Pending"}'),
      ),
    );
  }
}
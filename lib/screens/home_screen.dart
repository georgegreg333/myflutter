import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<TaskProvider>(context, listen: false).loadTasks()
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: tasks.isEmpty
          ? Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .toggleTaskStatus(task);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .removeTask(task.id!);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-task');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
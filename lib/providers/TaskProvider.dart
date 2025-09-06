import 'package:flutter/material.dart';
import '../model/task.dart';
import '../data/TaskData.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks;

  TaskProvider() : _tasks = List<Task>.from(tasks);

  List<Task> get allTasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void editTask(int id, String newTitle) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].title = newTitle;
      notifyListeners();
    }
  }

  void toggleComplete(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void deleteTask(int id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

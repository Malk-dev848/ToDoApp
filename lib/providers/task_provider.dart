import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasksBox');

  // List<Task> get tasks => _taskBox.values.toList();
  String _statusFilter = 'All';
  String _priorityFilter = 'All';
  List<Task> _allTasks = [];

  List<Task> get filteredTasks {
    return _allTasks.where((task) {
      final matchesStatus = _statusFilter == 'All' ||
          (_statusFilter == 'Completed' && task.isCompleted) ||
          (_statusFilter == 'Incomplete' && !task.isCompleted);

      final matchesPriority = _priorityFilter == 'All' ||
          task.priority == _priorityFilter;

      return matchesStatus && matchesPriority;
    }).toList();
  }

  void addTask(Task task) {
    _taskBox.put(task.id, task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.save();
    notifyListeners();
  }

  void deleteTask(String id) {
    _taskBox.delete(id);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    notifyListeners();
  }

   void setTasks(List<Task> tasks) {
    _allTasks = tasks;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(String priority) {
    _priorityFilter = priority;
    notifyListeners();
  }
}

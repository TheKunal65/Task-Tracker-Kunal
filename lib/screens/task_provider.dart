import 'package:codearies_kunal_prajapat/database/database.dart';
import 'package:codearies_kunal_prajapat/database/task.dart';
import 'package:flutter/material.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  List<Task> get tasks => _filteredTasks.isEmpty ? _tasks : _filteredTasks;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      _tasks = await DatabaseHelper().getTasks();
      _filteredTasks = _tasks;
      notifyListeners();
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await DatabaseHelper().insertTask(task);
      await fetchTasks(); // Refresh task list after adding
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await DatabaseHelper().updateTask(task);
      await fetchTasks();
    } catch (error) {
      print('Error updating task: $error');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await DatabaseHelper().deleteTask(id);
      await fetchTasks();
    } catch (error) {
      print('Error deleting task: $error');
    }
  }

  Future<void> toggleTaskStatus(Task task) async {
    try {
      final updatedTask = task.copyWith(status: !task.status);
      await DatabaseHelper().updateTask(updatedTask);
      await fetchTasks();
    } catch (error) {
      print('Error toggling task status: $error');
    }
  }

  void filterTasks(String query) {
    _filteredTasks = _tasks
        .where((task) => task.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void filterByCategory(String category) {
    if (category == 'ALL') {
      _filteredTasks = _tasks;
    } else {
      _filteredTasks =
          _tasks.where((task) => task.category == category).toList();
    }
    notifyListeners();
  }

  bool get hasNoTasks => _filteredTasks.isEmpty;
}

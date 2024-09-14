import 'dart:async';
import 'package:codearies_kunal_prajapat/database/task.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  String _searchQuery = '';
  String _selectedCategory = 'ALL';
  Timer? _debounce;

  List<Task> get tasks => _filteredTasks;
  bool get hasNoTasks => _filteredTasks.isEmpty && _selectedCategory != 'ALL';

  void loadTasks(List<Task> tasks) {
    _tasks = tasks;
    _applyFilters();
  }

  void filterTasks(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    List<Task> filteredTasks = _tasks;

    if (_searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedCategory != 'ALL') {
      filteredTasks = filteredTasks.where((task) {
        return task.category == _selectedCategory;
      }).toList();
    }

    _filteredTasks = filteredTasks;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    _applyFilters();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _applyFilters();
    }
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    _applyFilters();
  }

  void toggleTaskStatus(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final updatedTask = _tasks[index].copyWith(status: !_tasks[index].status);
      _tasks[index] = updatedTask;
      _applyFilters();
    }
  }
}

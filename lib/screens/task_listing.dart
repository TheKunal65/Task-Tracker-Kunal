import 'package:codearies_kunal_prajapat/screens/task_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<TaskProvider>(context, listen: false)
          .filterTasks(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Task Tracker',
          style: TextStyle(
            fontFamily: 'Dela',
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks',
                hintStyle: const TextStyle(
                    fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text(
                'Select category',
                style: TextStyle(
                    fontFamily: 'Outfit', fontWeight: FontWeight.bold),
              ),
              items: <String>['ALL', 'Work', 'Personal', 'Urgent']
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
                Provider.of<TaskProvider>(context, listen: false)
                    .filterByCategory(_selectedCategory ?? 'ALL');
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.hasNoTasks) {
                  return const Center(child: Text("No such tasks"));
                }

                return ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = provider.tasks[index];
                    final dateFormat = DateFormat('dd/MM/yyyy');
                    final timeFormat = DateFormat('HH:mm');
                    DateTime dueDate = DateTime.parse(task.dueDate);
                    return ListTile(
                      title: Text(
                        task.name,
                        style: const TextStyle(fontFamily: 'Dela'),
                      ),
                      subtitle: Text(
                        'Due: ${dateFormat.format(dueDate)} ${timeFormat.format(dueDate)}',
                        style: const TextStyle(
                            fontFamily: 'Outfit', fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: task.status,
                            onChanged: (bool? value) {
                              provider.toggleTaskStatus(task);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Delete Task"),
                                    content: const Text(
                                        "Are you sure you want to delete this task?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          provider.deleteTask(task.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Delete"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskFormScreen(task: task),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TaskFormScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

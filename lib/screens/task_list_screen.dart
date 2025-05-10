import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  const TaskListScreen(
      {Key? key, required this.onThemeToggle, required this.isDarkMode})
      : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Task? _selectedTask;
  String _statusFilter = 'All';
  String _priorityFilter = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Task>('tasks');

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onThemeToggle,
          ),
          if (_selectedTask != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirmed ?? false) {
                  await _selectedTask!.delete();
                  setState(() {
                    _selectedTask = null;
                  });
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by task name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                // Dropdown filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status filter with label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Status'),
                        DropdownButton<String>(
                          value: _statusFilter,
                          items:
                              ['All', 'Completed', 'Incomplete'].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _statusFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),

                    // Priority filter with label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Priority'),
                        DropdownButton<String>(
                          value: _priorityFilter,
                          items:
                              ['All', 'Low', 'Medium', 'High'].map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _priorityFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: taskBox.listenable(),
              builder: (context, Box<Task> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No tasks yet.'));
                }

                final filteredTasks = box.values.where((task) {
                  final matchesTitle = task.title
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());

                  final matchesStatus = _statusFilter == 'All' ||
                      (_statusFilter == 'Completed' && task.isCompleted) ||
                      (_statusFilter == 'Incomplete' && !task.isCompleted);

                  final matchesPriority = _priorityFilter == 'All' ||
                      task.priority == _priorityFilter;

                  return matchesTitle && matchesStatus && matchesPriority;
                }).toList();

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return ListTile(
                      selected: _selectedTask == task,
                      selectedTileColor: Colors.grey[200],
                      leading: task.image != null
                          ? Image.file(
                              File(task.image!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.task),
                      title: Text(task.title),
                      subtitle: Text(
                          task.dueDate?.toLocal().toString().split(' ')[0] ??
                              'No due date'),
                      trailing: Icon(
                        task.isCompleted
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isCompleted ? Colors.green : Colors.grey,
                      ),
                      // Tap: Navigate to edit. (Clears selection if any.)
                      onTap: () {
                        setState(() {
                          _selectedTask = null;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditTaskScreen(existingTask: task),
                          ),
                        );
                      },
                      // Long press: Select task for deletion.
                      onLongPress: () {
                        setState(() {
                          if (_selectedTask == task) {
                            // If already selected, unselect it.
                            _selectedTask = null;
                          } else {
                            _selectedTask = task;
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

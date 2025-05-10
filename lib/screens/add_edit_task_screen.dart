import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../models/task.dart'; // adjust the path as needed

class AddEditTaskScreen extends StatefulWidget {
  final Task? existingTask;

  const AddEditTaskScreen({Key? key, this.existingTask}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _dueDate;
  File? _pickedImage;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _titleController.text = widget.existingTask!.title;
      _dueDate = widget.existingTask!.dueDate;
      _isCompleted = widget.existingTask!.isCompleted;
      _selectedPriority = widget.existingTask!.priority;
      if (widget.existingTask!.image != null) {
        _pickedImage = File(widget.existingTask!.image!);
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  setState(() {
                    _pickedImage = File(photo.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final XFile? galleryImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (galleryImage != null) {
                  setState(() {
                    _pickedImage = File(galleryImage.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final taskBox = Hive.box<Task>('tasks');

    final task = Task(
      id: widget.existingTask?.id ?? DateTime.now().toIso8601String(),
      title: _titleController.text.trim(),
      dueDate: _dueDate,
      image: _pickedImage?.path,
      isCompleted: _isCompleted,
      priority: _selectedPriority,
    );

    if (widget.existingTask != null) {
      widget.existingTask!
        ..title = task.title
        ..dueDate = task.dueDate
        ..image = task.image
        ..isCompleted = task.isCompleted
        ..priority = task.priority
        ..save();
    } else {
      taskBox.add(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingTask != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter title'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(_dueDate != null
                      ? 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}'
                      : 'No due date'),
                  const Spacer(),
                  TextButton(
                    onPressed: _selectDueDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _pickedImage != null
                      ? Image.file(_pickedImage!,
                          width: 60, height: 60, fit: BoxFit.cover)
                      : const Text('No Image'),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image'),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                  const Text('Mark as completed'),
                ],
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: ['Low', 'Medium', 'High']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(
                    widget.existingTask != null ? 'Update Task' : 'Add Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

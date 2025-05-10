import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: onThemeToggle,
            activeColor: Colors.white,
          )
        ],
      ),
      body: const Center(child: Text("To-Do list will appear here")),
    );
  }
}

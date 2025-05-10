import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>('tasks'); 

  // Open the Hive box for tasks
  await Hive.openBox<Task>('tasksBox');

  runApp(
  ChangeNotifierProvider<TaskProvider>(
    create: (_) => TaskProvider(),
    child: const MyApp(),
  ),
);

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

 void toggleTheme() {
  setState(() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  });
}


 @override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'To-Do App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: _themeMode,
    home: TaskListScreen(
      onThemeToggle: toggleTheme,
      isDarkMode: _themeMode == ThemeMode.dark,
    ),
  );
}

}

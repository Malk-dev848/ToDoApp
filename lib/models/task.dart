import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0) low,
  @HiveField(1) medium,
  @HiveField(2) high,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String priority;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  String? image;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = 'Medium',
    this.dueDate,
    this.image,
  });
}

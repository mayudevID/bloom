import 'package:hive/hive.dart';
part 'task.g.dart';

@HiveType(typeId: 3)
class TaskModel {
  @HiveField(0)
  int taskId;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  String description;

  @HiveField(4)
  String tags;

  @HiveField(5)
  bool isRepeat;

  @HiveField(6)
  bool isTime;

  @HiveField(7)
  bool isChecked;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.tags,
    required this.isRepeat,
    required this.isTime,
    required this.isChecked,
  });
}

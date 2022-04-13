import 'package:hive/hive.dart';
part 'task.g.dart';

class Task {
  int taskId;
  String title;
  DateTime dateTime;
  String description;
  String tags;
  bool isRepeat;
  bool isTime;
  bool isChecked;

  Task({
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

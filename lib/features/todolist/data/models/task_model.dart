import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int taskId,
    required String title,
    required DateTime dateTime,
    required String description,
    required String tags,
    required bool isRepeat,
    required bool isTime,
    required bool isChecked,
  }) : super(
          taskId: taskId,
          title: title,
          dateTime: dateTime,
          description: description,
          tags: tags,
          isRepeat: isRepeat,
          isTime: isTime,
          isChecked: isChecked,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json["taskId"],
      title: json["title"],
      dateTime: json["dateTime"],
      description: json["description"],
      tags: json["tags"],
      isRepeat: json["isRepeat"],
      isTime: json["isTime"],
      isChecked: json["isChecked"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "taskId": taskId,
      "title": title,
      "dateTime": dateTime,
      "description": description,
      "tags": tags,
      "isRepeat": isRepeat,
      "isTime": isTime,
      "isChecked": isChecked,
    };
  }
}

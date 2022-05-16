import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  int taskId;
  String title;
  DateTime dateTime;
  String description;
  String tags;
  bool isRepeat;
  bool isTime;
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

  TaskModel copyWith({
    int? taskId,
    String? title,
    DateTime? dateTime,
    String? description,
    String? tags,
    bool? isRepeat,
    bool? isTime,
    bool? isChecked,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isRepeat: isRepeat ?? this.isRepeat,
      isTime: isTime ?? this.isTime,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}

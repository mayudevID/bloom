// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      taskId: json['taskId'] as int,
      title: json['title'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      description: json['description'] as String,
      tags: json['tags'] as String,
      isRepeat: json['isRepeat'] as bool,
      isTime: json['isTime'] as bool,
      isChecked: json['isChecked'] as bool,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'taskId': instance.taskId,
      'title': instance.title,
      'dateTime': instance.dateTime.toIso8601String(),
      'description': instance.description,
      'tags': instance.tags,
      'isRepeat': instance.isRepeat,
      'isTime': instance.isTime,
      'isChecked': instance.isChecked,
    };

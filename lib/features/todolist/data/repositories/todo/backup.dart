import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/task_model.dart';

class LocalStorageTodosIdle {
  LocalStorageTodosIdle(this.plugin);

  final SharedPreferences plugin;

  static const kTodosCollectionKey = '__todos_collection_key__';

  TaskModel? getData(int? id) {
    final tasksJson = plugin.getString(kTodosCollectionKey);
    if (tasksJson != null) {
      final tasks = List<Map>.from(json.decode(tasksJson) as List)
          .map((jsonMap) =>
              TaskModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      final taskIndex = tasks.indexWhere((h) => h.taskId == id);
      final taskModel = tasks[taskIndex];
      return taskModel;
    } else {
      return null;
    }
  }
}

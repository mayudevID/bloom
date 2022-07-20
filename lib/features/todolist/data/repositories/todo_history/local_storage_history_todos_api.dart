// ignore_for_file: avoid_renaming_method_parameters

import 'dart:convert';

import 'package:bloom/features/todolist/data/models/task_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todos_history_api.dart';

class LocalStorageHistoryTodosApi extends TodosHistoryApi {
  LocalStorageHistoryTodosApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _todoStreamController =
      BehaviorSubject<List<TaskModel>>.seeded(const []);

  @visibleForTesting
  static const kTodosCollectionKey = '__todos_history_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final todosJson = _getValue(kTodosCollectionKey);
    if (todosJson != null) {
      final todos = List<Map>.from(json.decode(todosJson) as List)
          .map((jsonMap) =>
              TaskModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _todoStreamController.add(todos);
    } else {
      _todoStreamController.add(const []);
    }
  }

  @override
  Stream<List<TaskModel>> getTodos() =>
      _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(TaskModel taskModel) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.taskId == taskModel.taskId);
    if (todoIndex >= 0) {
      todos[todoIndex] = taskModel;
    } else {
      todos.add(taskModel);
    }

    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, json.encode(todos));
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    // ignore: unrelated_type_equality_checks
    final todoIndex = todos.indexWhere((t) => t.taskId == int.tryParse(id));
    if (todoIndex == -1) {
      throw TodoHistoryNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      return _setValue(kTodosCollectionKey, json.encode(todos));
    }
  }
}

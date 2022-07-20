import 'package:bloom/features/todolist/data/models/task_model.dart';

abstract class TodosHistoryApi {
  const TodosHistoryApi();
  Stream<List<TaskModel>> getTodos();
  Future<void> saveTodo(TaskModel taskModel);
  Future<void> deleteTodo(String id);
}

class TodoHistoryNotFoundException implements Exception {}

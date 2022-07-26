import 'package:bloom/features/todolist/data/models/task_model.dart';

abstract class TodosApi {
  const TodosApi();
  Stream<List<TaskModel>> getTodos();
  Future<void> saveTodo(TaskModel taskModel);
  Future<void> deleteTodo(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
  Future<void> saveFromBackup(List<TaskModel> listTask);
}

class TodoNotFoundException implements Exception {}

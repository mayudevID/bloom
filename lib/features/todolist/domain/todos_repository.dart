import '../data/models/task_model.dart';
import '../data/repositories/todo/todos_api.dart';

class TodosRepository {
  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  final TodosApi _todosApi;

  Stream<List<TaskModel>> getTodos() => _todosApi.getTodos();
  Future<void> saveTodo(TaskModel todo) => _todosApi.saveTodo(todo);
  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);
  Future<int> clearCompleted() => _todosApi.clearCompleted();
  Future<int> completeAll({required bool isCompleted}) =>
      _todosApi.completeAll(isCompleted: isCompleted);
  Future<void> saveFromBackup(List<TaskModel> listTask) =>
      _todosApi.saveFromBackup(listTask);
}

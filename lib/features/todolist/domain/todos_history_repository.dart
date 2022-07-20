import '../data/models/task_model.dart';
import '../data/repositories/todo_history/todos_history_api.dart';

class TodosHistoryRepository {
  const TodosHistoryRepository({
    required TodosHistoryApi todosApi,
  }) : _todosApi = todosApi;

  final TodosHistoryApi _todosApi;

  Stream<List<TaskModel>> getTodos() => _todosApi.getTodos();
  Future<void> saveTodo(TaskModel todo) => _todosApi.saveTodo(todo);
  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);
}

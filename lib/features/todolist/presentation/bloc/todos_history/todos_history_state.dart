part of 'todos_history_bloc.dart';

enum TodosHistoryStatus { initial, loading, success, failure }

class TodosHistoryState extends Equatable {
  const TodosHistoryState({
    this.status = TodosHistoryStatus.initial,
    this.todos = const [],
  });

  final TodosHistoryStatus status;
  final List<TaskModel> todos;

  //Iterable<TaskModel> get filteredTodos => filter.applyAll(todos);

  TodosHistoryState copyWith({
    TodosHistoryStatus Function()? status,
    List<TaskModel> Function()? todos,
  }) {
    return TodosHistoryState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
      ];
}

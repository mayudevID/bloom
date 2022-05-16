// ignore_for_file: sdk_version_constructor_tearoffs

part of 'todos_overview_bloc.dart';

enum TodosOverviewStatus { initial, loading, success, failure }

class TodosOverviewState extends Equatable {
  TodosOverviewState({
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
    DateTime? filter,
    this.lastDeletedTodo,
  }) : filter = filter ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  final TodosOverviewStatus status;
  final List<TaskModel> todos;
  final DateTime? filter;
  final TaskModel? lastDeletedTodo;

  //Iterable<TaskModel> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<TaskModel> Function()? todos,
    DateTime Function()? filter,
    TaskModel? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedTodo,
      ];
}

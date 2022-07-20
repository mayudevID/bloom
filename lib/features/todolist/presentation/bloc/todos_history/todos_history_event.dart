part of 'todos_history_bloc.dart';

abstract class TodosHistoryEvent extends Equatable {
  const TodosHistoryEvent();

  @override
  List<Object> get props => [];
}

class TodosHistorySubscriptionRequested extends TodosHistoryEvent {
  const TodosHistorySubscriptionRequested();
}

class TodosHistoryTodoDeleted extends TodosHistoryEvent {
  const TodosHistoryTodoDeleted(this.todo);

  final TaskModel todo;

  @override
  List<Object> get props => [todo];
}

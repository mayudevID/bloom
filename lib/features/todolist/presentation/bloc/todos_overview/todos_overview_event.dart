part of 'todos_overview_bloc.dart';

abstract class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final TaskModel todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final TaskModel todo;

  @override
  List<Object> get props => [todo];
}

class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final DateTime filter;

  @override
  List<Object> get props => [filter];
}

// class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
//   const TodosOverviewToggleAllRequested();
// }

// class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
//   const TodosOverviewClearCompletedRequested();
// }

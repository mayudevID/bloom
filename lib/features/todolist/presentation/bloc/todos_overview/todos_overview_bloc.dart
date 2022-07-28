import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../authentication/data/models/user_data.dart';
import '../../../../authentication/data/repositories/local_auth_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/todos_history_repository.dart';
import '../../../domain/todos_repository.dart';

part 'todos_overview_event.dart';
part 'todos_overview_state.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodosOverviewState> {
  TodosOverviewBloc(
      {required TodosRepository todosRepository,
      required TodosHistoryRepository todosHistoryRepository,
      required LocalUserDataRepository localUserDataRepository})
      : _todosRepository = todosRepository,
        _todosHistoryRepository = todosHistoryRepository,
        _localUserDataRepository = localUserDataRepository,
        super(TodosOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosOverviewTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodosOverviewTodoDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeletionRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    //on<TodosOverviewToggleAllRequested>(_onToggleAllRequested);
    //on<TodosOverviewClearCompletedRequested>(_onClearCompletedRequested);
  }

  final TodosRepository _todosRepository;
  final TodosHistoryRepository _todosHistoryRepository;
  final LocalUserDataRepository _localUserDataRepository;

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));

    await emit.forEach<List<TaskModel>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    TodosOverviewTodoCompletionToggled event,
    Emitter<TodosOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isChecked: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
    final currUserData = _localUserDataRepository.getUserDataDirect();
    final newUserData = UserData(
      userId: currUserData.userId,
      email: currUserData.email,
      photoURL: currUserData.photoURL,
      name: currUserData.name,
      habitStreak: currUserData.habitStreak,
      taskCompleted: (event.isCompleted == true)
          ? currUserData.taskCompleted + 1
          : currUserData.taskCompleted - 1,
      totalFocus: currUserData.totalFocus,
      missed: currUserData.missed,
      completed: currUserData.completed,
      streakLeft: currUserData.streakLeft,
    );
    await _localUserDataRepository.saveUserData(newUserData);
  }

  Future<void> _onTodoDeleted(
    TodosOverviewTodoDeleted event,
    Emitter<TodosOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosRepository.deleteTodo(event.todo.taskId.toString());
    await _todosHistoryRepository.saveTodo(event.todo);
  }

  Future<void> _onUndoDeletionRequested(
    TodosOverviewUndoDeletionRequested event,
    Emitter<TodosOverviewState> emit,
  ) async {
    assert(
      state.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(todo);
  }

  void _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodosOverviewState> emit,
  ) {
    emit(state.copyWith(filter: () => event.filter));
  }

  // Future<void> _onToggleAllRequested(
  //   TodosOverviewToggleAllRequested event,
  //   Emitter<TodosOverviewState> emit,
  // ) async {
  //   final areAllCompleted = state.todos.every((todo) => todo.isCompleted);
  //   await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  // }

  // Future<void> _onClearCompletedRequested(
  //   TodosOverviewClearCompletedRequested event,
  //   Emitter<TodosOverviewState> emit,
  // ) async {
  //   await _todosRepository.clearCompleted();
  // }
}

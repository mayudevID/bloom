import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/task_model.dart';
import '../../../domain/todos_history_repository.dart';

part 'todos_history_event.dart';
part 'todos_history_state.dart';

class TodosHistoryBloc extends Bloc<TodosHistoryEvent, TodosHistoryState> {
  TodosHistoryBloc({required TodosHistoryRepository todosHistoryRepository})
      : _todosHistoryRepository = todosHistoryRepository,
        super(const TodosHistoryState()) {
    on<TodosHistorySubscriptionRequested>(_onSubscriptionRequested);
    on<TodosHistoryTodoDeleted>(_onTodoDeleted);
  }

  final TodosHistoryRepository _todosHistoryRepository;

  Future<void> _onSubscriptionRequested(
    TodosHistorySubscriptionRequested event,
    Emitter<TodosHistoryState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosHistoryStatus.loading));

    await emit.forEach<List<TaskModel>>(
      _todosHistoryRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosHistoryStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TodosHistoryStatus.failure,
      ),
    );
  }

  Future<void> _onTodoDeleted(
    TodosHistoryTodoDeleted event,
    Emitter<TodosHistoryState> emit,
  ) async {
    //emit(state.copyWith(lastDeletedTodo: () => event.todo));
    await _todosHistoryRepository.deleteTodo(event.todo.taskId.toString());
  }
}

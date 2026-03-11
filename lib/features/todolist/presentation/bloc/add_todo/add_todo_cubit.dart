import 'package:bloc/bloc.dart';
import '../../../../../core/utils/function.dart';
import '../../../domain/todos_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/notifications.dart';
import '../../../data/models/task_model.dart';

part 'add_todo_state.dart';

class AddTodoCubit extends Cubit<AddTodoState> {
  AddTodoCubit({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(AddTodoState.initial());
  final TodosRepository _todosRepository;

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value));
  }

  void timeChanged(DateTime time) {
    emit(state.copyWith(dateTime: time, isChoose: true));
  }

  void tagsChanged(String value) {
    emit(state.copyWith(tags: value));
  }

  void isTimeChanged(bool value) {
    if (value == false) {
      emit(state.copyWith(isTime: value, isChoose: value));
    } else {
      emit(state.copyWith(isTime: value));
    }
  }

  void saveTodo() async {
    try {
      final TaskModel taskModel = TaskModel(
        taskId: getRandomId(),
        title: state.title,
        dateTime: state.dateTime,
        description: state.description,
        tags: state.tags,
        isRepeat: false,
        isTime: state.isTime,
        isChecked: false,
      );

      if (state.isTime && state.isChoose) {
        createTaskNotification(taskModel);
      }

      await _todosRepository.saveTodo(taskModel);

      //return true;
    } catch (e) {
      //return false;
    }
  }
}

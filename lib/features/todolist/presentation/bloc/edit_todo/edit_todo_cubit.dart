import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/function.dart';
import '../../../../../core/utils/notifications.dart';
import '../../../data/models/task_model.dart';
import '../../../domain/todos_repository.dart';

part 'edit_todo_state.dart';

class EditTodoCubit extends Cubit<EditTodoState> {
  EditTodoCubit({
    required TodosRepository todosRepository,
    required TaskModel taskModel,
  })  : _todosRepository = todosRepository,
        _taskModel = taskModel,
        super(EditTodoState.initial(taskModel));

  final TodosRepository _todosRepository;
  final TaskModel _taskModel;

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
      TaskModel newTaskModel = TaskModel(
        taskId: _taskModel.taskId,
        title: state.title,
        dateTime: state.dateTime,
        description: state.description,
        tags: state.tags,
        isRepeat: state.isRepeat,
        isTime: state.isTime,
        isChecked: state.isChecked,
      );

      if (state.isTime && state.isChoose) {
        if (state.dateTime != _taskModel.dateTime) {
          AwesomeNotifications().cancel(_taskModel.taskId);
          createTaskNotification(newTaskModel);
        }
      } else if (state.isTime == false) {
        AwesomeNotifications().cancel(_taskModel.taskId);
      }

      await _todosRepository.saveTodo(newTaskModel);

      //return true;
    } catch (e) {
      //return false;
    }
  }
}

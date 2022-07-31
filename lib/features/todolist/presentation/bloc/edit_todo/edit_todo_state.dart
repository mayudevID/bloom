part of 'edit_todo_cubit.dart';

enum EditTodoStatus { init, load, saved, error }

class EditTodoState extends Equatable {
  final int taskId;
  final String title;
  final DateTime dateTime;
  final String description;
  final String tags;
  final bool isRepeat;
  final bool isTime;
  final bool isChecked;
  final bool isChoose;
  final EditTodoStatus editTodoStatus;
  final TaskModel newTaskModel;

  const EditTodoState({
    required this.taskId,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.tags,
    required this.isRepeat,
    required this.isTime,
    required this.isChecked,
    required this.isChoose,
    required this.editTodoStatus,
    required this.newTaskModel,
  });

  factory EditTodoState.initial(TaskModel taskModel) {
    return EditTodoState(
      taskId: taskModel.taskId,
      title: taskModel.title,
      dateTime: taskModel.dateTime,
      description: taskModel.description,
      tags: taskModel.tags,
      isRepeat: taskModel.isRepeat,
      isTime: taskModel.isTime,
      isChecked: taskModel.isChecked,
      isChoose: taskModel.isTime,
      editTodoStatus: EditTodoStatus.init,
      newTaskModel: taskModel,
    );
  }

  @override
  List<Object> get props => [
        taskId,
        title,
        dateTime,
        description,
        tags,
        isRepeat,
        isTime,
        isChecked,
        isChoose,
        editTodoStatus,
        newTaskModel,
      ];

  EditTodoState copyWith({
    int? taskId,
    String? title,
    DateTime? dateTime,
    String? description,
    String? tags,
    bool? isRepeat,
    bool? isTime,
    bool? isChecked,
    bool? isChoose,
    EditTodoStatus? editTodoStatus,
    TaskModel? newTaskModel,
  }) {
    return EditTodoState(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isRepeat: isRepeat ?? this.isRepeat,
      isTime: isTime ?? this.isTime,
      isChecked: isChecked ?? this.isChecked,
      isChoose: isChoose ?? this.isChoose,
      editTodoStatus: editTodoStatus ?? this.editTodoStatus,
      newTaskModel: newTaskModel ?? this.newTaskModel,
    );
  }
}

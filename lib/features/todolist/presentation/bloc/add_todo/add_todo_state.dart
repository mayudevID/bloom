part of 'add_todo_cubit.dart';

class AddTodoState extends Equatable {
  final int taskId;
  final String title;
  final DateTime dateTime;
  final String description;
  final String tags;
  final bool isRepeat;
  final bool isTime;
  final bool isChecked;
  final bool isChoose;

  const AddTodoState({
    required this.taskId,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.tags,
    required this.isRepeat,
    required this.isTime,
    required this.isChecked,
    required this.isChoose,
  });

  factory AddTodoState.initial() {
    return AddTodoState(
      taskId: 0,
      title: '',
      dateTime: DateTime(0),
      description: '',
      tags: 'Basic',
      isRepeat: false,
      isTime: false,
      isChecked: false,
      isChoose: false,
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
      ];

  AddTodoState copyWith({
    int? taskId,
    String? title,
    DateTime? dateTime,
    String? description,
    String? tags,
    bool? isRepeat,
    bool? isTime,
    bool? isChecked,
    bool? isChoose,
  }) {
    return AddTodoState(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isRepeat: isRepeat ?? this.isRepeat,
      isTime: isTime ?? this.isTime,
      isChecked: isChecked ?? this.isChecked,
      isChoose: isChoose ?? this.isChoose,
    );
  }
}

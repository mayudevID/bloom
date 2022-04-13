part of 'pomodoro_bloc.dart';

abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object> get props => [];
}

class DisplayPomodoroEvent extends PomodoroEvent {}

class DeletePomodoroEvent extends PomodoroEvent {
  final int index;

  const DeletePomodoroEvent({required this.index});

  @override
  List<Object> get props => [index];
}

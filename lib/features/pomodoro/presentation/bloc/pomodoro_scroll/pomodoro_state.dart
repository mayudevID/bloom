part of 'pomodoro_bloc.dart';

abstract class PomodoroState extends Equatable {
  const PomodoroState();

  @override
  List<Object> get props => [];
}

class PomodoroInitial extends PomodoroState {}

class DisplayPomodoroLoading extends PomodoroState {}

class DisplayPomodoroLoaded extends PomodoroState {
  final Map<int, Pomodoro> pomodoro;

  const DisplayPomodoroLoaded({required this.pomodoro});

  @override
  List<Object> get props => [pomodoro];
}

class DisplayPomodoroEmpty extends PomodoroState {}

class DisplayPomodoroError extends PomodoroState {
  final String message;

  const DisplayPomodoroError({required this.message});

  @override
  List<Object> get props => [message];
}

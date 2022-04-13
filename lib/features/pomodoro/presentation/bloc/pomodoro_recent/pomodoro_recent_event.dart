part of 'pomodoro_recent_bloc.dart';

abstract class PomodoroRecentEvent extends Equatable {
  const PomodoroRecentEvent();

  @override
  List<Object> get props => [];
}

class ChangedRecent extends PomodoroRecentEvent {
  final Pomodoro pomodoro;

  const ChangedRecent(this.pomodoro);

  @override
  List<Object> get props => [pomodoro];
}

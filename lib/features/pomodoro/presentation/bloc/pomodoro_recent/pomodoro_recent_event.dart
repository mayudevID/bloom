part of 'pomodoro_recent_bloc.dart';

abstract class PomodoroRecentEvent extends Equatable {
  const PomodoroRecentEvent();

  @override
  List<Object> get props => [];
}

class PomodoroRecentSubscriptionRequested extends PomodoroRecentEvent {
  const PomodoroRecentSubscriptionRequested();
}

class PomodoroRecentSaved extends PomodoroRecentEvent {
  const PomodoroRecentSaved(this.pomodoroModel);

  final PomodoroModel pomodoroModel;

  @override
  List<Object> get props => [pomodoroModel];
}

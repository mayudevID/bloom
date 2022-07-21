part of 'pomodoro_recent_bloc.dart';

enum PomodoroRecentStatus { initial, loading, success, failure }

class PomodoroRecentState extends Equatable {
  PomodoroRecentState({
    this.status = PomodoroRecentStatus.initial,
    PomodoroModel? pomodoro,
  }) : pomodoro = pomodoro ?? PomodoroModel.empty;

  final PomodoroRecentStatus status;
  final PomodoroModel pomodoro;

  //Iterable<PomodoroModel> get filteredPomodoro => filter.applyAll(pomodoro);

  PomodoroRecentState copyWith({
    PomodoroRecentStatus Function()? status,
    PomodoroModel Function()? pomodoro,
  }) {
    return PomodoroRecentState(
      status: status != null ? status() : this.status,
      pomodoro: pomodoro != null ? pomodoro() : this.pomodoro,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pomodoro,
      ];
}

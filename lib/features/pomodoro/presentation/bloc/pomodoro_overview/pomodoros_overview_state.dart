// ignore_for_file: sdk_version_constructor_tearoffs

part of 'pomodoros_overview_bloc.dart';

enum PomodorosOverviewStatus { initial, loading, success, failure }

class PomodorosOverviewState extends Equatable {
  PomodorosOverviewState({
    this.status = PomodorosOverviewStatus.initial,
    this.pomodoros = const [],
    DateTime? filter,
    this.lastDeletedPomodoro,
  }) : filter = filter ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  final PomodorosOverviewStatus status;
  final List<PomodoroModel> pomodoros;
  final DateTime? filter;
  final PomodoroModel? lastDeletedPomodoro;

  //Iterable<PomodoroModel> get filteredPomodoros => filter.applyAll(pomodoros);

  PomodorosOverviewState copyWith({
    PomodorosOverviewStatus Function()? status,
    List<PomodoroModel> Function()? pomodoros,
    DateTime Function()? filter,
    PomodoroModel? Function()? lastDeletedPomodoro,
  }) {
    return PomodorosOverviewState(
      status: status != null ? status() : this.status,
      pomodoros: pomodoros != null ? pomodoros() : this.pomodoros,
      filter: filter != null ? filter() : this.filter,
      lastDeletedPomodoro: lastDeletedPomodoro != null
          ? lastDeletedPomodoro()
          : this.lastDeletedPomodoro,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pomodoros,
        filter,
        lastDeletedPomodoro,
      ];
}

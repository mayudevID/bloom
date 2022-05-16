part of 'pomodoros_overview_bloc.dart';

abstract class PomodorosOverviewEvent extends Equatable {
  const PomodorosOverviewEvent();

  @override
  List<Object> get props => [];
}

class PomodorosOverviewSubscriptionRequested extends PomodorosOverviewEvent {
  const PomodorosOverviewSubscriptionRequested();
}

// class PomodorosOverviewPomodoroCompletionToggled extends PomodorosOverviewEvent {
//   const PomodorosOverviewPomodoroCompletionToggled({
//     required this.pomodoro,
//     required this.isCompleted,
//   });

//   final Pomodoro pomodoro;
//   final bool isCompleted;

//   @override
//   List<Object> get props => [pomodoro, isCompleted];
// }

class PomodorosOverviewPomodoroDeleted extends PomodorosOverviewEvent {
  const PomodorosOverviewPomodoroDeleted(this.pomodoro);

  final PomodoroModel pomodoro;

  @override
  List<Object> get props => [pomodoro];
}

class PomodorosOverviewUndoDeletionRequested extends PomodorosOverviewEvent {
  const PomodorosOverviewUndoDeletionRequested();
}

class PomodorosOverviewFilterChanged extends PomodorosOverviewEvent {
  const PomodorosOverviewFilterChanged(this.filter);

  final DateTime filter;

  @override
  List<Object> get props => [filter];
}

// class PomodorosOverviewToggleAllRequested extends PomodorosOverviewEvent {
//   const PomodorosOverviewToggleAllRequested();
// }

// class PomodorosOverviewClearCompletedRequested extends PomodorosOverviewEvent {
//   const PomodorosOverviewClearCompletedRequested();
// }

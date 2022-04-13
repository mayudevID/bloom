part of 'habits_overview_bloc.dart';

abstract class HabitsOverviewEvent extends Equatable {
  const HabitsOverviewEvent();

  @override
  List<Object> get props => [];
}

class HabitsOverviewSubscriptionRequested extends HabitsOverviewEvent {
  const HabitsOverviewSubscriptionRequested();
}

// class HabitsOverviewHabitCompletionToggled extends HabitsOverviewEvent {
//   const HabitsOverviewHabitCompletionToggled({
//     required this.habit,
//     required this.isCompleted,
//   });

//   final Habit habit;
//   final bool isCompleted;

//   @override
//   List<Object> get props => [habit, isCompleted];
// }

class HabitsOverviewHabitDeleted extends HabitsOverviewEvent {
  const HabitsOverviewHabitDeleted(this.habit);

  final HabitModel habit;

  @override
  List<Object> get props => [habit];
}

class HabitsOverviewUndoDeletionRequested extends HabitsOverviewEvent {
  const HabitsOverviewUndoDeletionRequested();
}

class HabitsOverviewFilterChanged extends HabitsOverviewEvent {
  const HabitsOverviewFilterChanged(this.filter);

  final DateTime filter;

  @override
  List<Object> get props => [filter];
}

// class HabitsOverviewToggleAllRequested extends HabitsOverviewEvent {
//   const HabitsOverviewToggleAllRequested();
// }

// class HabitsOverviewClearCompletedRequested extends HabitsOverviewEvent {
//   const HabitsOverviewClearCompletedRequested();
// }

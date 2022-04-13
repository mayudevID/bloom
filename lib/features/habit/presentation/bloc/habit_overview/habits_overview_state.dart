// ignore_for_file: sdk_version_constructor_tearoffs

part of 'habits_overview_bloc.dart';

enum HabitsOverviewStatus { initial, loading, success, failure }

class HabitsOverviewState extends Equatable {
  HabitsOverviewState({
    this.status = HabitsOverviewStatus.initial,
    this.habits = const [],
    DateTime? filter,
    this.lastDeletedHabit,
  }) : filter = filter ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            );

  final HabitsOverviewStatus status;
  final List<HabitModel> habits;
  final DateTime? filter;
  final HabitModel? lastDeletedHabit;

  //Iterable<HabitModel> get filteredHabits => filter.applyAll(habits);

  HabitsOverviewState copyWith({
    HabitsOverviewStatus Function()? status,
    List<HabitModel> Function()? habits,
    DateTime Function()? filter,
    HabitModel? Function()? lastDeletedHabit,
  }) {
    return HabitsOverviewState(
      status: status != null ? status() : this.status,
      habits: habits != null ? habits() : this.habits,
      filter: filter != null ? filter() : this.filter,
      lastDeletedHabit:
          lastDeletedHabit != null ? lastDeletedHabit() : this.lastDeletedHabit,
    );
  }

  @override
  List<Object?> get props => [
        status,
        habits,
        filter,
        lastDeletedHabit,
      ];
}

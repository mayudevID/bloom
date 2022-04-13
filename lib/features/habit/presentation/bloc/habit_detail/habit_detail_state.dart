part of 'habit_detail_bloc.dart';

class HabitDetailState extends Equatable {
  HabitDetailState({
    this.initialHabit,
    this.missed = 0,
    this.streak = 0,
    this.streakLeft = 0,
    List<bool>? checkedDays,
  }) : checkedDays = checkedDays ?? [];

  final HabitModel? initialHabit;
  final int missed;
  final int streak;
  final int streakLeft;
  final List<bool> checkedDays;

  HabitDetailState copyWith({
    HabitModel? initialHabit,
    int? missed,
    int? streak,
    int? streakLeft,
    List<bool>? checkedDays,
  }) {
    return HabitDetailState(
      initialHabit: initialHabit ?? this.initialHabit,
      missed: missed ?? this.missed,
      streak: streak ?? this.streak,
      streakLeft: streakLeft ?? this.streakLeft,
      checkedDays: checkedDays ?? this.checkedDays,
    );
  }

  @override
  List<Object> get props => [
        missed,
        initialHabit as Object,
        streak,
        streakLeft,
        checkedDays,
      ];
}

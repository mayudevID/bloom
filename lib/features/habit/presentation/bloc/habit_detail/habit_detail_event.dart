part of 'habit_detail_bloc.dart';

abstract class HabitDetailEvent extends Equatable {
  const HabitDetailEvent();

  @override
  List<Object> get props => [];
}

class HabitChanged extends HabitDetailEvent {
  final int missed;
  final int streak;
  final int streakLeft;
  final List<bool> checkedDays;

  const HabitChanged({
    required this.missed,
    required this.streak,
    required this.streakLeft,
    required this.checkedDays,
  });
}

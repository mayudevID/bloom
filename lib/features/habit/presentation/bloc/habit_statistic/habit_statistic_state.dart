part of 'habit_statistic_bloc.dart';

abstract class HabitStatisticState extends Equatable {
  const HabitStatisticState();

  @override
  List<Object> get props => [];
}

class HabitStatisticInitial extends HabitStatisticState {}

class HabitStatisticLoaded extends HabitStatisticState {
  const HabitStatisticLoaded(this.data);

  final UserData data;
}

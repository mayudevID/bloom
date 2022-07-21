part of 'habit_statistic_bloc.dart';

abstract class HabitStatisticEvent extends Equatable {
  const HabitStatisticEvent();

  @override
  List<Object> get props => [];
}

class GetAllStatistic extends HabitStatisticEvent {
  const GetAllStatistic();
}

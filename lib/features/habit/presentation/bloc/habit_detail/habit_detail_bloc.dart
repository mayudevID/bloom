import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/habit_model.dart';

part 'habit_detail_event.dart';
part 'habit_detail_state.dart';

class HabitDetailBloc extends Bloc<HabitDetailEvent, HabitDetailState> {
  final HabitsRepository _habitsRepository;
  HabitDetailBloc({
    required HabitsRepository habitsRepository,
    required HabitModel? habitModel,
  })  : _habitsRepository = habitsRepository,
        super(
          HabitDetailState(
            initialHabit: habitModel,
            missed: habitModel!.missed,
            streak: habitModel.streak,
            streakLeft: habitModel.streakLeft,
            checkedDays: habitModel.checkedDays,
          ),
        ) {
    on<HabitChanged>(_onChanged);
  }

  Future<void> _onChanged(
      HabitChanged event, Emitter<HabitDetailState> emit) async {
    // ignore: todo
    // TODO: implement event handler

    final habit = (state.initialHabit ?? emptyModel()).copyWith(
      missed: event.missed,
      streak: event.streak,
      streakLeft: event.streakLeft,
      checkedDays: event.checkedDays,
    );

    try {
      await _habitsRepository.saveHabit(habit);
      emit(state.copyWith(
        missed: event.missed,
        streak: event.streak,
        streakLeft: event.streakLeft,
        checkedDays: event.checkedDays,
      ));
      // ignore: empty_catches
    } catch (e) {}
  }
}

HabitModel emptyModel() {
  return HabitModel(
    habitId: 0,
    iconImg: "",
    title: "",
    goals: "",
    timeOfDay: DateTime.now(),
    durationDays: 0,
    missed: 0,
    streak: 0,
    streakLeft: 0,
    dayList: [],
    checkedDays: [],
    openDays: [],
  );
}

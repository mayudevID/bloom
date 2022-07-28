import 'package:bloc/bloc.dart';
import 'package:bloom/features/authentication/data/models/user_data.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/habit_model.dart';

part 'habit_detail_event.dart';
part 'habit_detail_state.dart';

class HabitDetailBloc extends Bloc<HabitDetailEvent, HabitDetailState> {
  final HabitsRepository _habitsRepository;
  final LocalUserDataRepository _localUserDataRepository;

  HabitDetailBloc({
    required HabitsRepository habitsRepository,
    required LocalUserDataRepository localUserDataRepository,
    required HabitModel? habitModel,
  })  : _habitsRepository = habitsRepository,
        _localUserDataRepository = localUserDataRepository,
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
    final habit = (state.initialHabit ?? emptyModel()).copyWith(
      missed: event.missed,
      streak: event.streak,
      streakLeft: event.streakLeft,
      checkedDays: event.checkedDays,
    );

    try {
      await _habitsRepository.saveHabit(habit);
      final oldUserData = _localUserDataRepository.getUserDataDirect();
      final newUserData = UserData(
        userId: oldUserData.userId,
        email: oldUserData.email,
        photoURL: oldUserData.photoURL,
        name: oldUserData.name,
        habitStreak: oldUserData.habitStreak + 1,
        taskCompleted: oldUserData.taskCompleted,
        totalFocus: oldUserData.totalFocus,
        missed: oldUserData.missed,
        completed: oldUserData.completed,
        streakLeft: oldUserData.streakLeft,
      );
      await _localUserDataRepository.saveUserData(newUserData);
      emit(
        state.copyWith(
          missed: event.missed,
          streak: event.streak,
          streakLeft: event.streakLeft,
          checkedDays: event.checkedDays,
        ),
      );
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

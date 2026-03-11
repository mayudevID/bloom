import 'package:bloc/bloc.dart';
import '../../../../authentication/data/models/user_data.dart';
import '../../../../authentication/data/repositories/local_auth_repository.dart';
import '../../../domain/habits_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/habit_model.dart';

part 'habit_detail_event.dart';
part 'habit_detail_state.dart';

class HabitDetailBloc extends Bloc<HabitDetailEvent, HabitDetailState> {

  HabitDetailBloc({
    required HabitsRepository habitsRepository,
    required LocalUserDataRepository localUserDataRepository,
    required HabitModel habitModel,
  })  : _habitsRepository = habitsRepository,
        _localUserDataRepository = localUserDataRepository,
        super(
          HabitDetailState(
            initialHabit: habitModel,
            missed: habitModel.missed,
            streak: habitModel.streak,
            streakLeft: habitModel.streakLeft,
            checkedDays: habitModel.checkedDays,
          ),
        ) {
    on<HabitChanged>(_onChanged);
  }
  final HabitsRepository _habitsRepository;
  final LocalUserDataRepository _localUserDataRepository;

  Future<void> _onChanged(
      HabitChanged event, Emitter<HabitDetailState> emit) async {
    final isChecked = event.missed < state.missed;

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
        habitStreak: (isChecked)
            ? oldUserData.habitStreak + 1
            : oldUserData.habitStreak - 1,
        taskCompleted: oldUserData.taskCompleted,
        totalFocus: oldUserData.totalFocus,
        missed: (isChecked) ? oldUserData.missed - 1 : oldUserData.missed + 1,
        completed:
            (isChecked) ? oldUserData.completed + 1 : oldUserData.completed - 1,
        streakLeft: (isChecked)
            ? oldUserData.streakLeft - 1
            : oldUserData.streakLeft + 1,
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

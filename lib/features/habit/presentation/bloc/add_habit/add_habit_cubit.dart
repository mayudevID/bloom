import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/authentication/data/models/user_data.dart';
import 'package:bloom/features/authentication/data/repositories/local_auth_repository.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/utils/constant.dart';
import '../../../../../core/utils/notifications.dart';

part 'add_habit_state.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  AddHabitCubit({
    required HabitsRepository habitsRepository,
    required LocalUserDataRepository localUserDataRepository,
  })  : _habitsRepository = habitsRepository,
        _localUserDataRepository = localUserDataRepository,
        super(AddHabitState.initial());

  final HabitsRepository _habitsRepository;
  final LocalUserDataRepository _localUserDataRepository;

  void iconChanged(int value) {
    String iconTarget = iconLocation[value];
    emit(state.copyWith(iconImg: iconTarget, selectedIcon: value));
  }

  void titleChanged(String value) {
    emit(state.copyWith(title: value));
  }

  void goalsChanged(String value) {
    emit(state.copyWith(goals: value));
  }

  void timeChanged(DateTime time) {
    emit(state.copyWith(timeOfDay: time));
  }

  void durationChanged(int value) {
    emit(state.copyWith(durationDays: value));
  }

  void dayListChanged(int val) {
    switch (val) {
      case 0:
        emit(state.copyWith(sunday: !state.sunday));
        break;
      case 1:
        emit(state.copyWith(monday: !state.monday));
        break;
      case 2:
        emit(state.copyWith(tuesday: !state.tuesday));
        break;
      case 3:
        emit(state.copyWith(wednesday: !state.wednesday));
        break;
      case 4:
        emit(state.copyWith(thursday: !state.thursday));
        break;
      case 5:
        emit(state.copyWith(friday: !state.friday));
        break;
      case 6:
        emit(state.copyWith(saturday: !state.saturday));
        break;
    }
  }

  void checkedDaysChanged(List<bool> value) {
    emit(state.copyWith(checkedDays: value));
  }

  void openDaysChanged(List<bool> value) {
    emit(state.copyWith(openDays: value));
  }

  void saveHabit() async {
    try {
      Map<int, bool> dayMap = [
        state.sunday,
        state.monday,
        state.tuesday,
        state.wednesday,
        state.thursday,
        state.friday,
        state.saturday
      ].asMap();

      List<int> dayListOn = [];
      dayMap.forEach((key, value) {
        if (value == true) {
          if (key == 0) {
            dayListOn.add(7);
          } else {
            dayListOn.add(key);
          }
        }
      });

      if (kDebugMode) {
        print(dayListOn);
      }

      HabitModel habitModel = HabitModel(
        habitId: getRandomId(),
        iconImg: state.iconImg,
        title: state.title,
        goals: state.goals,
        timeOfDay: state.timeOfDay,
        durationDays: state.durationDays,
        missed: state.missed,
        streak: state.streak,
        streakLeft: state.durationDays,
        dayList: dayListOn,
        checkedDays: List.filled(state.durationDays, false),
        openDays: List.filled(state.durationDays, false),
      );

      for (var i = 0; i < habitModel.dayList.length; i++) {
        createHabitNotification(habitModel, habitModel.dayList[i]);
      }

      await _habitsRepository.saveHabit(habitModel);

      final oldUserData = _localUserDataRepository.getUserDataDirect();
      final newUserData = UserData(
        userId: oldUserData.userId,
        email: oldUserData.email,
        photoURL: oldUserData.photoURL,
        name: oldUserData.name,
        habitStreak: oldUserData.habitStreak,
        taskCompleted: oldUserData.taskCompleted,
        totalFocus: oldUserData.totalFocus,
        missed: oldUserData.missed,
        completed: oldUserData.completed,
        streakLeft: oldUserData.streakLeft + state.durationDays,
      );

      await _localUserDataRepository.saveUserData(newUserData);
    } catch (e) {
      throw Exception();
    }
  }
}

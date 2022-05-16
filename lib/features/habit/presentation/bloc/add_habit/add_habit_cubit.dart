import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/function.dart';
import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/constant.dart';
import '../../../../../core/utils/notifications.dart';

part 'add_habit_state.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  final HabitsRepository _habitsRepository;

  AddHabitCubit(this._habitsRepository) : super(AddHabitState.initial());

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

  // void missedChanged(int value) {
  //   emit(state.copyWith(missed: value));
  // }

  // void streakChanged(int value) {
  //   emit(state.copyWith(streak: value));
  // }

  // void streakLeftChanged(int value) {
  //   emit(state.copyWith(streakLeft: value));
  // }

  void dayListChanged(int value) {
    List<bool> newDaysList = state.dayList;
    newDaysList[value] = !newDaysList[value];
    emit(state.copyWith(dayList: newDaysList));
  }

  void checkedDaysChanged(List<bool> value) {
    emit(state.copyWith(checkedDays: value));
  }

  void openDaysChanged(List<bool> value) {
    emit(state.copyWith(openDays: value));
  }

  void saveHabit() async {
    try {
      Map<int, bool> dayMap = state.dayList.asMap();

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

      //EDIT USER

      /////////

      await _habitsRepository.saveHabit(habitModel);
    } catch (e) {}
  }
}

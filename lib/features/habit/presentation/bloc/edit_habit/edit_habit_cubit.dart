import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/utils/constant.dart';
import '../../../../../core/utils/notifications.dart';
import '../../../../authentication/data/models/user_data.dart';
import '../../../../authentication/data/repositories/local_auth_repository.dart';
import '../../../data/models/habit_model.dart';
import '../../../domain/habits_repository.dart';

part 'edit_habit_state.dart';

class EditHabitCubit extends Cubit<EditHabitState> {
  EditHabitCubit(
      {required HabitsRepository habitsRepository,
      required LocalUserDataRepository localUserDataRepository,
      required HabitModel habitModel})
      : _habitsRepository = habitsRepository,
        _localUserDataRepository = localUserDataRepository,
        _habitModel = habitModel,
        super(EditHabitState.initial(habitModel));

  final HabitsRepository _habitsRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final HabitModel _habitModel;

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
    emit(state.copyWith(editHabitStatus: EditHabitStatus.load));
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

      List<bool> addMoreDays(List<bool> old) {
        final temp = old.toList();
        final addNew =
            List.filled(state.durationDays - _habitModel.durationDays, false);
        temp.addAll(addNew);
        return temp;
      }

      HabitModel newHabitModel = HabitModel(
        habitId: _habitModel.habitId,
        iconImg: state.iconImg,
        title: state.title,
        goals: state.goals,
        timeOfDay: state.timeOfDay,
        durationDays: state.durationDays,
        missed: state.missed,
        streak: state.streak,
        streakLeft: state.durationDays -
            state.checkedDays.where((element) => element == true).length,
        dayList: dayListOn,
        checkedDays: (_habitModel.durationDays < state.durationDays)
            ? addMoreDays(state.checkedDays)
            : state.checkedDays.take(state.durationDays).toList(),
        openDays: (_habitModel.durationDays < state.durationDays)
            ? addMoreDays(state.openDays)
            : state.openDays.take(state.durationDays).toList(),
      );

      if (listEquals(_habitModel.dayList, newHabitModel.dayList) == false ||
          _habitModel.timeOfDay != newHabitModel.timeOfDay) {
        for (var i = 0; i < _habitModel.dayList.length; i++) {
          AwesomeNotifications().cancel(
            _habitModel.habitId * _habitModel.dayList[i],
          );
        }
        for (var i = 0; i < newHabitModel.dayList.length; i++) {
          createHabitNotification(newHabitModel, newHabitModel.dayList[i]);
        }
      }

      await _habitsRepository.saveHabit(newHabitModel);

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
        streakLeft: (_habitModel.durationDays < state.durationDays)
            ? oldUserData.streakLeft +
                (state.durationDays - _habitModel.durationDays)
            : oldUserData.streakLeft -
                (_habitModel.durationDays - state.durationDays),
      );

      await _localUserDataRepository.saveUserData(newUserData);

      final getNewData = await _habitsRepository.getHabits().first;
      final newDataRecentIndex = getNewData
          .indexWhere((element) => element.habitId == _habitModel.habitId);

      emit(state.copyWith(
        editHabitStatus: EditHabitStatus.saved,
        newHabitModel: getNewData[newDataRecentIndex],
      ));
    } on Exception {
      emit(state.copyWith(editHabitStatus: EditHabitStatus.error));
      // print(e);
      throw Exception();
    }
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/function.dart';
import '../../../habitlist/data/models/task_model.dart';
import '../models/pomodoro_model.dart';

abstract class PomodoroDataSource {
  Future<Map<int, PomodoroModel>> getPomodoro();
  Future<Map<int, PomodoroModel>> addPomodoro(PomodoroModel pomodoro);
  Future<Map<int, PomodoroModel>> deletePomodoro(int index);
  Future<PomodoroModel> changeRecentPomodoro(PomodoroModel pomodoro);
}

class PomodoroDataSourceImpl implements PomodoroDataSource {
  final SharedPreferences sharedPreferences;

  PomodoroDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Map<int, PomodoroModel>> getPomodoro() async {
    // ignore: habit
    // TODO: implement deletePomodoro
    final jsonStringList = sharedPreferences.getStringList(POMODORO_DB);

    if (jsonStringList != null) {
      Map<int, PomodoroModel> pomodoroList = {};
      for (var i = 0; i < jsonStringList.length; i++) {
        pomodoroList[i] =
            PomodoroModel.fromJson(json.decode(jsonStringList[i]));
      }
      return pomodoroList;
    } else {
      return {};
    }
  }

  @override
  Future<Map<int, PomodoroModel>> deletePomodoro(int index) async {
    // ignore: habit
    // TODO: implement getPomodoro
    final jsonStringList = sharedPreferences.getStringList(POMODORO_DB);

    if (jsonStringList != null) {
      Map<int, PomodoroModel> pomodoroList = {};
      jsonStringList.removeAt(index);
      sharedPreferences.setStringList(POMODORO_DB, jsonStringList);
      for (var i = 0; i < jsonStringList.length; i++) {
        pomodoroList[i] =
            PomodoroModel.fromJson(json.decode(jsonStringList[i]));
      }
      return pomodoroList;
    } else {
      return {};
    }
  }

  @override
  Future<Map<int, PomodoroModel>> addPomodoro(PomodoroModel pomodoro) async {
    final jsonStringList = sharedPreferences.getStringList(POMODORO_DB) ?? [];
    Map<int, PomodoroModel> pomodoroList = {};
    jsonStringList.add(json.encode(pomodoro.toJson()));
    sharedPreferences.setStringList(POMODORO_DB, jsonStringList);
    for (var i = 0; i < jsonStringList.length; i++) {
      pomodoroList[i] = PomodoroModel.fromJson(json.decode(jsonStringList[i]));
    }
    return pomodoroList;
  }

  @override
  Future<PomodoroModel> changeRecentPomodoro(PomodoroModel pomodoro) {
    // ignore: habit
    // TODO: implement changeRecentPomodoro
    throw UnimplementedError();
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit_model.dart';

class LocalStorageHabitsIdle {
  LocalStorageHabitsIdle(this.plugin);

  final SharedPreferences plugin;

  static const kHabitsCollectionKey = '__habits_collection_key__';

  void getSave(int? id) {
    final habitsJson = plugin.getString(kHabitsCollectionKey);
    if (habitsJson != null) {
      final habits = List<Map>.from(json.decode(habitsJson) as List)
          .map((jsonMap) =>
              HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      final habitIndex = habits.indexWhere((h) => h.habitId == id);
      final habitModel = habits[habitIndex];
      int openDaysVal =
          habitModel.openDays.where((item) => item == true).length;
      if (openDaysVal < habitModel.openDays.length) {
        List<bool> newOpenDays = habitModel.openDays;
        newOpenDays[openDaysVal] = true;
        habitModel.copyWith(
          missed: habitModel.missed + 1,
          openDays: newOpenDays,
        );
        habits[habitIndex] = habitModel;
        plugin.setString(kHabitsCollectionKey, json.encode(habits));
        //EDIT USER
      }
    }
  }

  HabitModel? getData(int? id) {
    final habitsJson = plugin.getString(kHabitsCollectionKey);
    if (habitsJson != null) {
      final habits = List<Map>.from(json.decode(habitsJson) as List)
          .map((jsonMap) =>
              HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      final habitIndex = habits.indexWhere((h) => h.habitId == id);
      final habitModel = habits[habitIndex];
      return habitModel;
    } else {
      return null;
    }
  }
}

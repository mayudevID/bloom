// ignore_for_file: avoid_renaming_method_parameters

import 'dart:convert';

import 'package:bloom/features/habit/data/models/habit_model.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'habits_api.dart';

class LocalStorageHabitsApi extends HabitsApi {
  LocalStorageHabitsApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _habitStreamController =
      BehaviorSubject<List<HabitModel>>.seeded(const []);

  @visibleForTesting
  static const kHabitsCollectionKey = '__habits_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final habitsJson = _getValue(kHabitsCollectionKey);
    if (habitsJson != null) {
      final habits = List<Map>.from(json.decode(habitsJson) as List)
          .map((jsonMap) =>
              HabitModel.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();
      _habitStreamController.add(habits);
    } else {
      _habitStreamController.add(const []);
    }
  }

  @override
  Stream<List<HabitModel>> getHabits() =>
      _habitStreamController.asBroadcastStream();

  @override
  Future<void> saveHabit(HabitModel habitMo) {
    final habits = [..._habitStreamController.value];
    final habitIndex = habits.indexWhere((t) => t.habitId == habitMo.habitId);
    if (habitIndex >= 0) {
      habits[habitIndex] = habitMo;
    } else {
      habits.add(habitMo);
    }

    _habitStreamController.add(habits);
    return _setValue(kHabitsCollectionKey, json.encode(habits));
  }

  @override
  Future<void> deleteHabit(String id) async {
    final habits = [..._habitStreamController.value];
    // ignore: unrelated_type_equality_checks
    final habitIndex = habits.indexWhere((t) => t.habitId == id);
    if (habitIndex == -1) {
      throw HabitsNotFoundException();
    } else {
      habits.removeAt(habitIndex);
      _habitStreamController.add(habits);
      return _setValue(kHabitsCollectionKey, json.encode(habits));
    }
  }

  @override
  Future<int> clearCompleted() {
    // TODO: implement clearCompleted
    throw UnimplementedError();
  }

  @override
  Future<int> completeAll({required bool isCompleted}) {
    // TODO: implement completeAll
    throw UnimplementedError();
  }

  // @override
  // Future<int> clearCompleted() async {
  //   final habits = [..._habitStreamController.value];
  //   final completedHabitssAmount = habits.where((t) => t.isCompleted).length;
  //   habits.removeWhere((t) => t.isCompleted);
  //   _habitStreamController.add(habits);
  //   await _setValue(kHabitssCollectionKey, json.encode(habits));
  //   return completedHabitssAmount;
  // }

  // @override
  // Future<int> completeAll({required bool isCompleted}) async {
  //   final habits = [..._habitStreamController.value];
  //   final changedHabitssAmount =
  //       habits.where((t) => t.isCompleted != isCompleted).length;
  //   final newHabitss = [
  //     for (final habit in habits) habit.copyWith(isCompleted: isCompleted)
  //   ];
  //   _habitStreamController.add(newHabitss);
  //   await _setValue(kHabitssCollectionKey, json.encode(newHabitss));
  //   return changedHabitssAmount;
  // }
}

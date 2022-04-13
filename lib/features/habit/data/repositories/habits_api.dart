import 'package:bloom/features/habit/data/models/habit_model.dart';

abstract class HabitsApi {
  const HabitsApi();
  Stream<List<HabitModel>> getHabits();
  Future<void> saveHabits(HabitModel habitModel);
  Future<void> deleteHabits(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
}

class HabitsNotFoundException implements Exception {}

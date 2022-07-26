import 'package:bloom/features/habit/data/models/habit_model.dart';

abstract class HabitsApi {
  const HabitsApi();
  Stream<List<HabitModel>> getHabits();
  Future<void> saveHabit(HabitModel habitModel);
  Future<void> deleteHabit(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
  Future<void> saveFromBackup(List<HabitModel> listHabit);
}

class HabitsNotFoundException implements Exception {}

import '../data/models/habit_model.dart';
import '../data/repositories/habits_api.dart';

class HabitsRepository {
  const HabitsRepository({
    required HabitsApi habitsApi,
  }) : _habitsApi = habitsApi;

  final HabitsApi _habitsApi;

  Stream<List<HabitModel>> getHabits() => _habitsApi.getHabits();
  Future<void> saveHabit(HabitModel habit) => _habitsApi.saveHabit(habit);
  Future<void> deleteHabit(String id) => _habitsApi.deleteHabit(id);
  Future<int> clearCompleted() => _habitsApi.clearCompleted();
  Future<int> completeAll({required bool isCompleted}) =>
      _habitsApi.completeAll(isCompleted: isCompleted);
}

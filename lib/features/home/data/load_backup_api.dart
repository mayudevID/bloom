import '../../habit/data/models/habit_model.dart';
import '../../pomodoro/data/models/pomodoro_model.dart';
import '../../todolist/data/models/task_model.dart';

abstract class LoadBackupApi {
  Future<List<PomodoroModel>?> getPomodoroBackup();
  Future<List<TaskModel>?> getTodoBackup();
  Future<List<HabitModel>?> getHabitBackup();
}

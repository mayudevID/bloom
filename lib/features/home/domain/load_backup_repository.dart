import '../../habit/data/models/habit_model.dart';
import '../../pomodoro/data/models/pomodoro_model.dart';
import '../../todolist/data/models/task_model.dart';
import '../data/load_backup_api.dart';

class LoadBackupRepository {
  const LoadBackupRepository({
    required LoadBackupApi loadBackupApi,
  }) : _loadBackupApi = loadBackupApi;

  final LoadBackupApi _loadBackupApi;

  Future<List<PomodoroModel>?> getPomodoroBackup() =>
      _loadBackupApi.getPomodoroBackup();
  Future<List<TaskModel>?> getTodoBackup() => _loadBackupApi.getTodoBackup();
  Future<List<HabitModel>?> getHabitBackup() => _loadBackupApi.getHabitBackup();
}

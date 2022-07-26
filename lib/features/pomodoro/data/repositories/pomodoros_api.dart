import '../../../pomodoro/data/models/pomodoro_model.dart';

abstract class PomodorosApi {
  const PomodorosApi();
  Stream<List<PomodoroModel>> getPomodoros();
  Stream<PomodoroModel> getRecentList();
  Future<void> savePomodoro(PomodoroModel pomodoroModel);
  Future<void> saveRecentList(PomodoroModel pomodoroModel);
  Future<void> deletePomodoro(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
  Future<void> saveFromBackup(List<PomodoroModel> listPomodoro);
}

class PomodorosNotFoundException implements Exception {}

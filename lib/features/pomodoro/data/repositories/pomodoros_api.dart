import '../../../pomodoro/data/models/pomodoro_model.dart';

abstract class PomodorosApi {
  const PomodorosApi();
  Stream<List<PomodoroModel>> getPomodoros();
  Future<void> savePomodoro(PomodoroModel pomodoroModel);
  Future<void> deletePomodoro(String id);
  Future<int> clearCompleted();
  Future<int> completeAll({required bool isCompleted});
}

class PomodorosNotFoundException implements Exception {}

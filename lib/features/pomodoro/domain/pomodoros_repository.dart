import '../data/models/pomodoro_model.dart';
import '../data/repositories/pomodoros_api.dart';

class PomodorosRepository {
  const PomodorosRepository({
    required PomodorosApi pomodorosApi,
  }) : _pomodorosApi = pomodorosApi;

  final PomodorosApi _pomodorosApi;

  Stream<List<PomodoroModel>> getPomodoros() => _pomodorosApi.getPomodoros();
  Stream<PomodoroModel> getRecentList() => _pomodorosApi.getRecentList();
  Future<void> savePomodoro(PomodoroModel pomodoro) =>
      _pomodorosApi.savePomodoro(pomodoro);
  Future<void> saveRecentList(PomodoroModel pomodoro) =>
      _pomodorosApi.saveRecentList(pomodoro);
  Future<void> deletePomodoro(String id) => _pomodorosApi.deletePomodoro(id);
  Future<int> clearCompleted() => _pomodorosApi.clearCompleted();
  Future<int> completeAll({required bool isCompleted}) =>
      _pomodorosApi.completeAll(isCompleted: isCompleted);
  Future<void> saveFromBackup(List<PomodoroModel> listPomodoro) =>
      _pomodorosApi.saveFromBackup(listPomodoro);
}

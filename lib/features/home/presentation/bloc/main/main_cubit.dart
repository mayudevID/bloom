import 'package:bloc/bloc.dart';
import 'package:bloom/core/utils/notifications.dart';
import 'package:equatable/equatable.dart';

import '../../../../habit/domain/habits_repository.dart';
import '../../../../pomodoro/domain/pomodoros_repository.dart';
import '../../../../todolist/domain/todos_repository.dart';
import '../../../domain/load_backup_repository.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit({
    required PomodorosRepository pomodorosRepository,
    required TodosRepository todosRepository,
    required HabitsRepository habitsRepository,
    required LoadBackupRepository loadBackupRepository,
  })  : _pomodorosRepository = pomodorosRepository,
        _todosRepository = todosRepository,
        _habitsRepository = habitsRepository,
        _loadBackupRepository = loadBackupRepository,
        super(const MainState());

  final PomodorosRepository _pomodorosRepository;
  final TodosRepository _todosRepository;
  final HabitsRepository _habitsRepository;
  final LoadBackupRepository _loadBackupRepository;

  void setTab(MainTab tab) {
    emit(MainState(tab: tab, status: LoadStatus.done));
  }

  Future<void> getDataBackup(bool isGetData) async {
    if (isGetData == false) {
      emit(const MainState(status: LoadStatus.done));
      return;
    }
    emit(const MainState(status: LoadStatus.load));

    final pomodorosData = await _loadBackupRepository.getPomodoroBackup();
    final todosData = await _loadBackupRepository.getTodoBackup();
    final habitsData = await _loadBackupRepository.getHabitBackup();

    if (pomodorosData != null) {
      _pomodorosRepository.saveFromBackup(pomodorosData);
    }

    if (todosData != null) {
      for (final taskModel in todosData) {
        if (taskModel.dateTime.isAfter(DateTime.now())) {
          createTaskNotification(taskModel);
        }
      }
      _todosRepository.saveFromBackup(todosData);
    }

    if (habitsData != null) {
      for (final habitModel in habitsData) {
        for (var i = 0; i < habitModel.dayList.length; i++) {
          createHabitNotification(habitModel, habitModel.dayList[i]);
        }
      }
      _habitsRepository.saveFromBackup(habitsData);
    }

    emit(const MainState(status: LoadStatus.finish));
  }

  void finishToDone() {
    emit(const MainState(status: LoadStatus.done));
  }
}

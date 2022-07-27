import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/pomodoro/domain/pomodoros_repository.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/data/repositories/auth_repository.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';
import '../../domian/save_backup_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required AuthRepository authRepository,
    required LocalUserDataRepository localUserDataRepository,
    required SaveBackupRepository saveBackupRepository,
    required PomodorosRepository pomodorosRepository,
    required HabitsRepository habitsRepository,
    required TodosRepository todosRepository,
  })  : _authRepository = authRepository,
        _localUserDataRepository = localUserDataRepository,
        _saveBackupRepository = saveBackupRepository,
        _pomodorosRepository = pomodorosRepository,
        _habitsRepository = habitsRepository,
        _todosRepository = todosRepository,
        super(SettingsState.initial());

  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final SaveBackupRepository _saveBackupRepository;
  final PomodorosRepository _pomodorosRepository;
  final HabitsRepository _habitsRepository;
  final TodosRepository _todosRepository;

  Future<void> logOut() async {
    if (state.logoutStatus == LogoutStatus.processing ||
        state.backupStatus == BackupStatus.processing) {
      return;
    }
    emit(state.copyWith(logoutStatus: LogoutStatus.processing));
    try {
      await _authRepository.signOut();
      await _localUserDataRepository.deleteUserData();
      await _pomodorosRepository.clearCompleted();
      await _habitsRepository.clearCompleted();
      await _todosRepository.clearCompleted();
      emit(state.copyWith(logoutStatus: LogoutStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          logoutStatus: LogoutStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> backupData() async {
    if (state.logoutStatus == LogoutStatus.processing ||
        state.backupStatus == BackupStatus.processing) {
      return;
    }
    emit(state.copyWith(backupStatus: BackupStatus.processing));
    try {
      await _saveBackupRepository.backupData();
      emit(state.copyWith(backupStatus: BackupStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          backupStatus: BackupStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

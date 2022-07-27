import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/pomodoro/domain/pomodoros_repository.dart';
import 'package:bloom/features/todolist/domain/todos_history_repository.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    required TodosHistoryRepository todosHistoryRepository,
  })  : _authRepository = authRepository,
        _localUserDataRepository = localUserDataRepository,
        _saveBackupRepository = saveBackupRepository,
        _pomodorosRepository = pomodorosRepository,
        _habitsRepository = habitsRepository,
        _todosRepository = todosRepository,
        _todosHistoryRepository = todosHistoryRepository,
        super(SettingsState.initial(
          saveBackupRepository.getUpdateDate(),
        ));

  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final SaveBackupRepository _saveBackupRepository;
  final PomodorosRepository _pomodorosRepository;
  final HabitsRepository _habitsRepository;
  final TodosRepository _todosRepository;
  final TodosHistoryRepository _todosHistoryRepository;

  Future<void> logOut() async {
    if (state.logoutStatus == LogoutStatus.processing ||
        state.backupStatus == BackupStatus.processing) {
      return;
    }
    emit(state.copyWith(logoutStatus: LogoutStatus.processing));
    try {
      final oldUserData = _localUserDataRepository.getUserDataDirect();
      CachedNetworkImage.evictFromCache(oldUserData.photoURL as String);
      await _authRepository.signOut();
      await _localUserDataRepository.deleteUserData();
      await _pomodorosRepository.clearCompleted();
      await _habitsRepository.clearCompleted();
      await _todosRepository.clearCompleted();
      await _todosHistoryRepository.clearCompleted();
      await _saveBackupRepository.deleteUpdateDate();
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
      final updateAt = await _saveBackupRepository.backupData();
      emit(
        state.copyWith(
          backupStatus: BackupStatus.success,
          updatedAt: updateAt,
        ),
      );
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

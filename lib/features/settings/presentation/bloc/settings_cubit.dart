import 'package:bloc/bloc.dart';
import 'package:bloom/features/habit/domain/habits_repository.dart';
import 'package:bloom/features/pomodoro/domain/pomodoros_repository.dart';
import 'package:bloom/features/settings/domian/settings_repository.dart';
import 'package:bloom/features/todolist/domain/todos_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/data/repositories/auth_repository.dart';
import '../../../authentication/data/repositories/local_auth_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AuthRepository _authRepository;
  final LocalUserDataRepository _localUserDataRepository;
  final SettingsRepository _settingsRepository;

  SettingsCubit({
    required AuthRepository authRepository,
    required LocalUserDataRepository localUserDataRepository,
    required SettingsRepository settingsRepository,
  })  : _authRepository = authRepository,
        _localUserDataRepository = localUserDataRepository,
        _settingsRepository = settingsRepository,
        super(SettingsState.initial());

  Future<void> logOut() async {
    if (state.logoutStatus == LogoutStatus.processing ||
        state.backupStatus == BackupStatus.processing) {
      return;
    }
    emit(state.copyWith(logoutStatus: LogoutStatus.processing));
    try {
      await _authRepository.signOut();
      await _localUserDataRepository.deleteUserData();
      emit(state.copyWith(logoutStatus: LogoutStatus.success));
    } catch (e) {}
  }

  Future<void> backupData() async {
    if (state.logoutStatus == LogoutStatus.processing ||
        state.backupStatus == BackupStatus.processing) {
      return;
    }
    emit(state.copyWith(backupStatus: BackupStatus.processing));
    try {
      await _settingsRepository.backupData();
      emit(state.copyWith(backupStatus: BackupStatus.success));
    } catch (e) {}
  }
}

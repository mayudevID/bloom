part of 'settings_cubit.dart';

enum LogoutStatus { initial, processing, success, error }

enum BackupStatus { initial, processing, success, error }

class SettingsState extends Equatable {
  final LogoutStatus logoutStatus;
  final BackupStatus backupStatus;

  const SettingsState({
    required this.logoutStatus,
    required this.backupStatus,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      logoutStatus: LogoutStatus.initial,
      backupStatus: BackupStatus.initial,
    );
  }

  @override
  List<Object> get props => [logoutStatus, backupStatus];

  SettingsState copyWith({
    LogoutStatus? logoutStatus,
    BackupStatus? backupStatus,
  }) {
    return SettingsState(
      logoutStatus: logoutStatus ?? this.logoutStatus,
      backupStatus: backupStatus ?? this.backupStatus,
    );
  }
}

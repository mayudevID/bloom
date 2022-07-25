part of 'settings_cubit.dart';

enum LogoutStatus { initial, processing, success, error }

enum BackupStatus { initial, processing, success, error }

class SettingsState extends Equatable {
  final LogoutStatus logoutStatus;
  final BackupStatus backupStatus;
  final String errorMessage;

  const SettingsState({
    required this.logoutStatus,
    required this.backupStatus,
    required this.errorMessage,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      logoutStatus: LogoutStatus.initial,
      backupStatus: BackupStatus.initial,
      errorMessage: '',
    );
  }

  @override
  List<Object> get props => [logoutStatus, backupStatus];

  SettingsState copyWith({
    LogoutStatus? logoutStatus,
    BackupStatus? backupStatus,
    String? errorMessage,
  }) {
    return SettingsState(
      logoutStatus: logoutStatus ?? this.logoutStatus,
      backupStatus: backupStatus ?? this.backupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

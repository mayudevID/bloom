part of 'settings_cubit.dart';

enum LogoutStatus { initial, processing, success, error }

enum BackupStatus { initial, processing, success, error }

class SettingsState extends Equatable {
  final LogoutStatus logoutStatus;
  final BackupStatus backupStatus;
  final String errorMessage;
  final DateTime updatedAt;

  const SettingsState({
    required this.logoutStatus,
    required this.backupStatus,
    required this.errorMessage,
    required this.updatedAt,
  });

  factory SettingsState.initial(DateTime? initUpdatedAt) {
    return SettingsState(
      logoutStatus: LogoutStatus.initial,
      backupStatus: BackupStatus.initial,
      errorMessage: '',
      updatedAt: (initUpdatedAt != null) ? initUpdatedAt : DateTime(0),
    );
  }

  @override
  List<Object> get props => [
        logoutStatus,
        backupStatus,
        errorMessage,
        updatedAt,
      ];

  SettingsState copyWith({
    LogoutStatus? logoutStatus,
    BackupStatus? backupStatus,
    String? errorMessage,
    DateTime? updatedAt,
  }) {
    return SettingsState(
      logoutStatus: logoutStatus ?? this.logoutStatus,
      backupStatus: backupStatus ?? this.backupStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

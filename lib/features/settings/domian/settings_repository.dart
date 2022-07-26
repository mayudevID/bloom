import '../data/settings_api.dart';

class SaveBackupRepository {
  const SaveBackupRepository({
    required SettingsApi saveBackupApi,
  }) : _saveBackupApi = saveBackupApi;

  final SettingsApi _saveBackupApi;

  Future<void> backupData() => _saveBackupApi.backupData();
}

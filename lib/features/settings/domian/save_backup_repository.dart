import '../data/save_backup_api.dart';

class SaveBackupRepository {
  const SaveBackupRepository({
    required SaveBackupApi saveBackupApi,
  }) : _saveBackupApi = saveBackupApi;

  final SaveBackupApi _saveBackupApi;

  Future<void> backupData() => _saveBackupApi.backupData();
}

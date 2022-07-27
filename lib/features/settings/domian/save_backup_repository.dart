import '../data/save_backup_api.dart';

class SaveBackupRepository {
  const SaveBackupRepository({
    required SaveBackupApi saveBackupApi,
  }) : _saveBackupApi = saveBackupApi;

  final SaveBackupApi _saveBackupApi;

  Future<DateTime> backupData() => _saveBackupApi.backupData();
  DateTime? getUpdateDate() => _saveBackupApi.getUpdateDate();
  Future<void> deleteUpdateDate() => _saveBackupApi.deleteUpdateDate();
}

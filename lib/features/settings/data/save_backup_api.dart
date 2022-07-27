abstract class SaveBackupApi {
  const SaveBackupApi();

  DateTime? getUpdateDate();
  Future<DateTime> backupData();
  Future<void> deleteUpdateDate();
}

class BackupException implements Exception {}

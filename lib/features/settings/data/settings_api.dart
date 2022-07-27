abstract class SaveBackupApi {
  const SaveBackupApi();

  Future<void> backupData() async {}
}

class BackupException implements Exception {}

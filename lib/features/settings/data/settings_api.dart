abstract class SettingsApi {
  const SettingsApi();

  Future<void> backupData() async {}
}

class BackupException implements Exception {}

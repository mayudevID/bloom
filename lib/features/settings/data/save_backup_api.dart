import '../../authentication/data/models/user_data.dart';

abstract class SaveBackupApi {
  const SaveBackupApi();

  DateTime? getUpdateDate();
  Future<DateTime> backupData(UserData statData);
  Future<void> deleteUpdateDate();
}

class BackupException implements Exception {}

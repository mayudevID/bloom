import '../../authentication/data/models/user_data.dart';
import '../data/save_backup_api.dart';

class SaveBackupRepository {
  const SaveBackupRepository({
    required SaveBackupApi saveBackupApi,
  }) : _saveBackupApi = saveBackupApi;

  final SaveBackupApi _saveBackupApi;

  Future<DateTime> backupData(UserData statData) =>
      _saveBackupApi.backupData(statData);
  DateTime? getUpdateDate() => _saveBackupApi.getUpdateDate();
  Future<void> deleteUpdateDate() => _saveBackupApi.deleteUpdateDate();
}

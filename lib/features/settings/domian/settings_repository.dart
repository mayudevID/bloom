import '../data/settings_api.dart';

class SettingsRepository {
  const SettingsRepository({
    required SettingsApi settingsApi,
  }) : _settingsApi = settingsApi;

  final SettingsApi _settingsApi;

  Future<void> backupData() => _settingsApi.backupData();
}


import 'package:linum/core/settings/data/settings_data.dart';

abstract class ISettingsStorage {
  Future<SettingsData?> getDataForUser();
  Stream<SettingsData> getDataStreamForUser();

  Future<void> updateUserData(SettingsData data);
}

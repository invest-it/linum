
import 'package:linum/core/settings/data/settings_data.dart';

abstract class ISettingsAdapter {
  Future<SettingsData> getDataForUser(String? userId);
  Stream<SettingsData> getDataStreamForUser(String? userId);

  Future<void> updateUserData(String? userId, SettingsData data);
}

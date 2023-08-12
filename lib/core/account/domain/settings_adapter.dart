
import 'package:linum/core/account/data/models/settings_data.dart';

abstract class ISettingsAdapter {
  Future<SettingsData> getDataForUser(String? userId);
  Stream<SettingsData> getDataStreamForUser(String? userId);

  Future<void> updateUserData(String? userId, SettingsData data);
}

import 'package:linum/common/interfaces/service_interface.dart';

abstract class ILanguageSettingsService extends IProvidableService with NotifyReady {
  String? getLanguageTag();
  Future<void> setLanguageTag(String? languageCode);
  Future<void> setUseSystemLanguage(bool value);
  bool get useSystemLanguage;

  bool isCurrentLanguageTag(String code);
}

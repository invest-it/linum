import 'dart:async';

import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/events/models/language_change_event.dart';
import 'package:linum/core/localization/settings/data/language_settings.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';

class LanguageSettingsServiceImpl extends SubscriptionHandler implements ILanguageSettingsService {
  final ISettingsRepository<LanguageSettings> _repository;
  final EventService _eventService;


  LanguageSettingsServiceImpl(this._repository, this._eventService) {
    super.subscribe(_repository.settingsStream, (event) {
      _eventService.dispatch(LanguageChangeEvent(
        message: event.languageCode,
        sender: (LanguageSettingsServiceImpl).toString(),
      ),);
      notifyListeners();
    });
  }

  @override
  String? getLanguageCode() {
    return _repository.settings.languageCode;
  }

  @override
  Future<void> setLanguageCode(String? languageCode) {
    if (languageCode == null) {
      return setUseSystemLanguage(true);
    }

    final update = _repository.settings.copyWith(
      languageCode: languageCode,
      useSystemLanguage: false,
    );
    return _repository.update(update);
  }

  @override
  bool get useSystemLanguage {
    return _repository.settings.useSystemLanguage ?? true;
  }

  @override
  Future<void> setUseSystemLanguage(bool value) async {
    final update = LanguageSettings(
      useSystemLanguage: value,
      languageCode: null,
    );
    await _repository.update(update);
  }

  @override
  bool isCurrentLanguageCode(String code) {
    if (useSystemLanguage) {
      return false;
    }
    return code == getLanguageCode();
  }

}

import 'dart:async';

import 'package:linum/common/utils/subscription_handler.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/events/models/language_change_event.dart';
import 'package:linum/core/localization/settings/data/language_settings.dart';
import 'package:linum/core/localization/settings/presentation/language_settings_service.dart';
import 'package:linum/core/settings/domain/settings_repository.dart';
import 'package:logger/logger.dart';

class LanguageSettingsServiceImpl extends SubscriptionHandler implements ILanguageSettingsService {
  final ISettingsRepository<LanguageSettings> _repository;
  final EventService _eventService;


  LanguageSettingsServiceImpl(this._repository, this._eventService) {
    // print("Constructor called");
    super.subscribe(_repository.settingsStream, (event) {
      // print(event);
      _eventService.dispatch(LanguageChangeEvent(
        message: event.languageTag,
        sender: (LanguageSettingsServiceImpl).toString(),
      ),);
      notifyListeners();
    });
  }

  @override
  String? getLanguageTag() {
    final languageTag = _repository.settings.languageTag;
    return languageTag;
  }

  @override
  Future<void> setLanguageTag(String? languageTag) async {
    if (languageTag == null) {
      return setUseSystemLanguage(true);
    }
    // TODO: Handle case of user not authorized

    final update = _repository.settings.copyWith(
      languageTag: languageTag,
      useSystemLanguage: false,
    );

    try {
      await _repository.update(update);
    } on Exception catch (e) {
      Logger().e(e);
    }

    _eventService.dispatch(
      LanguageChangeEvent(
        message: languageTag,
        sender: (LanguageSettingsServiceImpl).toString(),
      ),
    );
  }

  @override
  bool get useSystemLanguage {
    return _repository.settings.useSystemLanguage ?? false;
  }

  @override
  Future<void> setUseSystemLanguage(bool value) async {
    final update = LanguageSettings(
      useSystemLanguage: value,
      languageTag: null,
    );
    await _repository.update(update);
  }

  @override
  bool isCurrentLanguageTag(String code) {
    if (useSystemLanguage) {
      return false;
    }

    return code == getLanguageTag();
  }

}

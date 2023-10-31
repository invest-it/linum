import 'package:easy_localization/easy_localization.dart';
import 'package:linum/common/interfaces/translator.dart';

// Depends on the EasyLocalization Widget
class BaseTranslator implements ITranslator {
  final String language;

  BaseTranslator(this.language);

  @override
  String translate(String key) {
    return tr(key);
  }

  @override
  String languageCode() {
    return language;
  }


}

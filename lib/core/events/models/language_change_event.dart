import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_types.dart';

class LanguageChangeEvent extends IEvent {
  LanguageChangeEvent({required super.message, required super.sender})
      : super(type: EventType.languageChange);

}

import 'package:linum/core/events/event_interface.dart';

class Event extends IEvent {
  Event({required super.type, required super.message, required super.sender});
}

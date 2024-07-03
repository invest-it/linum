import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_types.dart';

class UserChangeEvent extends IEvent {
  UserChangeEvent({required super.message, required super.sender}) : super(type: EventType.userChange);
}

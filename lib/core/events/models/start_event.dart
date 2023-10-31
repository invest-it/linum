import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_types.dart';

class StartEvent extends IEvent {
  StartEvent(): super(sender: "EventService", message: "EventService ready!", type: EventType.start);
}

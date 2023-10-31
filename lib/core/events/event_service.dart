import 'package:flutter/cupertino.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/models/start_event.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';


class EventService extends ChangeNotifier {
  final BehaviorSubject<IEvent> _behaviorSubject = BehaviorSubject();

  EventService() {
    dispatch(StartEvent());
  }

  /// Get the all events with the "global" audience
  Stream<IEvent> getGlobalEventStream() {
    return getEventStream("global");
  }

  Stream<IEvent> getEventStream(String audience) => _behaviorSubject.stream
    .where(
      (event) => event.audience == audience,
    );

  /// Dispatches an event to the EventStream,
  /// will notify all listeners of the events audience
  /// Can be used to pass messages between components
  /// without them knowing about each other
  void dispatch(IEvent event) {
    Logger().i(event);
    _behaviorSubject.add(event);
  }
}

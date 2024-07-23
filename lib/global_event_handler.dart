import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:linum/core/events/event_types.dart';
import 'package:provider/provider.dart';

typedef AppEventListener = void Function(IEvent event, BuildContext context);

/// Listens for all events with a global audience. // TODO: change
/// Passes the event information to the registered listeners.
class EventListener extends StatefulWidget {
  final Widget child;
  final Stream<IEvent>? eventStream;
  final String? streamName;
  final Map<EventType, List<AppEventListener>> listeners;

  const EventListener({
    super.key,
    this.eventStream,
    this.streamName,
    required this.listeners,
    required this.child,
  }) : assert(eventStream != null || streamName != null);

  @override
  State<EventListener> createState() => _EventListenerState();
}

class _EventListenerState extends State<EventListener> {
  StreamSubscription? subscription;



  // TODO: Update
  @override
  void didChangeDependencies() {
    subscription?.cancel();
    
    Stream<IEvent>? eventStream = widget.eventStream;
    
    if (widget.eventStream == null) {
      eventStream = context.read<EventService>().getEventStream(widget.streamName ?? "global");
    }
    
    subscription = eventStream?.listen((IEvent event) {
      for (final AppEventListener listener in widget.listeners[EventType.any] ?? []) {
        listener(event, context);
      }
      for (final AppEventListener listener in widget.listeners[event.type] ?? []) {
        listener(event, context);
      }
    });
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}

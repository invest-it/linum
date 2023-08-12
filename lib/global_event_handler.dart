import 'package:flutter/material.dart';
import 'package:linum/core/events/event_interface.dart';
import 'package:linum/core/events/event_service.dart';
import 'package:provider/provider.dart';

typedef AppEventListener = void Function(IEvent event, BuildContext context);

class GlobalEventListener extends StatelessWidget {
  final Widget child;
  final List<AppEventListener> listeners;

  const GlobalEventListener({
    super.key,
    required this.child,
    required this.listeners,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<IEvent>(
      stream: context.read<EventService>().eventStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (final listener in listeners) {
            listener(snapshot.requireData, context);
          }
        }
        return child;
      },
    );
  }
}

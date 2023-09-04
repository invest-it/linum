import 'package:linum/core/events/event_types.dart';

abstract class IEvent {
  final EventType type;
  final String? message;
  final String? sender;
  final String? audience;

  IEvent({
    required this.type,
    required this.message,
    required this.sender,
    this.audience = "global",
  });

  @override
  String toString() {
    return 'IEvent(type: '
        '$type, message: '
        '$message, sender: '
        '$sender, runtimeType: '
        '$runtimeType)';
  }
}

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:linum/backend_functions/notification_utilities.dart';

Future<void> createSingleNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.money_money_bag} Test test',
      body: 'Add your expenses now!',
    ),
  );
}

Future<void> createScheduledNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'scheduled_channel',
      title:
          '${Emojis.money_money_bag} Have you already add your expenses today?',
      body: 'Add your expenses now!',
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(key: 'MARK_DONE', label: 'Mark done')
    ],
    schedule: NotificationCalendar(
      hour: 20,
      minute: 0,
      second: 0,
      millisecond: 0,
      timeZone: AwesomeNotifications.localTimeZoneIdentifier,
      repeats: true,
      allowWhileIdle: true,
    ),
  );
}

Future<void> cancelScheduledNotifications() async {
  await AwesomeNotifications().cancelAllSchedules();
}

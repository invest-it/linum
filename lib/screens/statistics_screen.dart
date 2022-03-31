import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/notification_notifications.dart';
import 'package:linum/backend_functions/notification_utilities.dart';
import 'package:linum/screens/home_screen.dart';
import 'package:linum/screens/settings_screen.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/top_bar_action_item.dart';

/// Page Index: 2
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _notificationState = false;

  @override
  /*void initState() {
    super.initState();
    AwesomeNotifications().createdStream.listen((notification) {
      log("${notification.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notification created on ${notification.id} ${notification.body} ${notification.displayedDate} ${notification.displayedLifeCycle} ',
          ),
        ),
      );
    });
    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
                  AwesomeNotifications().setGlobalBadgeCounter(value - 1),
            );
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
          (route) => route.isFirst);
    });
  }*/

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'Stats',
      body: Center(
        child: SwitchListTile(
          title: const Text("Daily Notifications"),
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (bool value) {
            setState(() {
              _notificationState = value;
            });
          },
          value: _notificationState,
        ),

        /*Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TopBarActionItem(
                buttonIcon: Icons.build,
                onPressedAction: () => log('message'),
              ),
              Text(AppLocalizations.of(context)!.translate('main/label-wip')),
            ],
          ),*/
      ),
      isInverted: true,
    );
  }
}

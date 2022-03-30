import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';

abstract class AppBarAction {
  static final Map<DefaultAction, Widget Function(BuildContext)>
      _defaultActionButtons = {
    DefaultAction.notification: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.notifications,
        ontap: () => log('Notification feature is not implemented yet.'),
      );
    },
    DefaultAction.filter: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.filter_list_alt,
        ontap: () => log('Filter feature is not implemented yet.'),
      );
    },
    DefaultAction.academy: (BuildContext context) {
      final ScreenIndexProvider screenIndexProvider =
          Provider.of<ScreenIndexProvider>(context);
      return AppBarAction.fromParameters(
        icon: Icons.video_library_rounded,
        ontap: () {
          screenIndexProvider.setPageIndex(4);
        },
      );
    },
    DefaultAction.settings: (BuildContext context) {
      final ScreenIndexProvider screenIndexProvider =
          Provider.of<ScreenIndexProvider>(context);
      return AppBarAction.fromParameters(
        icon: Icons.settings_rounded,
        ontap: () {
          screenIndexProvider.setPageIndex(3);
        },
      );
    },
    DefaultAction.back: (BuildContext context) => const BackButton(),
    DefaultAction.close: (BuildContext context) => const CloseButton(),
  };

  static IconButton fromParameters({
    required IconData icon,
    required void Function() ontap,
    bool active = true,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => active ? ontap() : {},
    );
  }

  static Widget Function(BuildContext) fromPreset(DefaultAction preset) {
    return _defaultActionButtons[preset]!;
  }
}

enum DefaultAction {
  academy,
  notification,
  filter,
  back,
  close,
  settings,
}

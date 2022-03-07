import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/backend_functions/url-handler.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:provider/provider.dart';

abstract class AppBarAction {
  static final Map<DefaultAction, Widget Function(BuildContext)>
      _defaultActionButtons = {
    DefaultAction.NOTIFICATION: (BuildContext context) {
      return AppBarAction.fromParameters(
          icon: Icons.notifications,
          ontap: () => log('Notification feature is not implemented yet.'));
    },
    DefaultAction.FILTER: (BuildContext context) {
      return AppBarAction.fromParameters(
          icon: Icons.filter_list_alt,
          ontap: () => log('Filter feature is not implemented yet.'));
    },
    DefaultAction.ACADEMY: (BuildContext context) {
      ScreenIndexProvider screenIndexProvider =
          Provider.of<ScreenIndexProvider>(context);
      return AppBarAction.fromParameters(
          icon: Icons.video_library_rounded,
          ontap: () {
            screenIndexProvider.setPageIndex(4);
          });
    },
    DefaultAction.SETTINGS: (BuildContext context) {
      ScreenIndexProvider screenIndexProvider =
          Provider.of<ScreenIndexProvider>(context);
      return AppBarAction.fromParameters(
          icon: Icons.settings_rounded,
          ontap: () {
            screenIndexProvider.setPageIndex(3);
          });
    },
    DefaultAction.BACK: (BuildContext context) => BackButton(),
    DefaultAction.CLOSE: (BuildContext context) => CloseButton(),
  };

  static IconButton fromParameters(
      {required IconData icon,
      required void Function() ontap,
      bool active = true}) {
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
  ACADEMY,
  NOTIFICATION,
  FILTER,
  BACK,
  CLOSE,
  SETTINGS,
}

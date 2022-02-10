import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:linum/backend_functions/url-handler.dart';

abstract class AppBarAction {
  static final Map<DefaultAction, Widget> _defaultActionButtons = {
    DefaultAction.NOTIFICATION: AppBarAction.fromParameters(
        icon: Icons.notifications,
        ontap: () => log('Notification feature is not implemented yet.')),
    DefaultAction.FILTER: AppBarAction.fromParameters(
        icon: Icons.filter_list_alt,
        ontap: () => log('Filter feature is not implemented yet.')),
    DefaultAction.ACADEMY: AppBarAction.fromParameters(
        icon: Icons.video_library_rounded,
        ontap: () {
          launchURL('https://youtube.investit-academy.de');
        }),
    DefaultAction.BACK: BackButton(),
    DefaultAction.CLOSE: CloseButton(),
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

  static Widget fromPreset(DefaultAction preset) {
    return _defaultActionButtons[preset]!;
  }
}

enum DefaultAction {
  ACADEMY,
  NOTIFICATION,
  FILTER,
  BACK,
  CLOSE,
}

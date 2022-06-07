//  App Bar Action - a standardized action that can be added to an AppBar.
//  Note: You need to use the static functions below if you want customized AppBarActions.
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linum/navigation/main_router_delegate.dart';
import 'package:linum/navigation/main_routes.dart';

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
      return AppBarAction.fromParameters(
        icon: Icons.video_library_rounded,
        ontap: () => Get.find<MainRouterDelegate>()
            .pushRoute(MainRoute.academy), // TODO: Find out why app closes on back-navigation
      );
    },
    DefaultAction.settings: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.settings_rounded,
        ontap: () => Get.find<MainRouterDelegate>()
            .replaceLastRoute(MainRoute.settings),
      );
    },
    // TODO: Are these guys even used?
    DefaultAction.back: (BuildContext context) => const BackButton(),
    DefaultAction.close: (BuildContext context) => const CloseButton(),
  };

  static IconButton fromParameters({
    required IconData icon,
    required void Function() ontap,
    bool active = true,
    Key? key,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => active ? ontap() : {},
      key: key,
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

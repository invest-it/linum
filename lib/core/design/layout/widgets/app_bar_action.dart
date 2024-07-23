//  App Bar Action - a standardized action that can be added to an AppBar.
//  Note: You need to use the static functions below if you want customized AppBarActions.
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:flutter/material.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';
import 'package:logger/logger.dart';
import 'package:wiredash/wiredash.dart';

const Color lipContextColor = Color(
  0xFFC1E695,
); //FUTURE TODO: We should not hardcode things. This should be drawn from the colorTheme in the future.

abstract class AppBarAction {
  static Logger logger = Logger();

  static final Map<DefaultAction, Widget Function(BuildContext)>
      _defaultActionButtons = {
    DefaultAction.notification: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.notifications,
        ontap: () => logger.i('Notification feature is not implemented yet.'),
      );
    },
    DefaultAction.filter: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.filter_list_alt,
        ontap: () => logger.i('Filter feature is not implemented yet.'),
      );
    },
    DefaultAction.academy: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.video_library_rounded,
        ontap: () => context.getMainRouterDelegate().pushRoute(
              MainRoute.academy,
            ),
      );
    },
    DefaultAction.bugreport: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.bug_report_rounded,
        ontap: () => Wiredash.of(context).show(inheritMaterialTheme: true),
      );
    },
    DefaultAction.settings: (BuildContext context) {
      return AppBarAction.fromParameters(
        icon: Icons.settings_rounded,
        ontap: () => context.getMainRouterDelegate().replaceLastRoute(
              MainRoute.settings,
              rememberReplacedRoute: true,
            ),
      );
    },
    DefaultAction.back: (BuildContext context) => const BackButton(
          color: lipContextColor,
        ),
    DefaultAction.close: (BuildContext context) => const CloseButton(),
  };

  static IconButton fromParameters({
    required IconData icon,
    required void Function() ontap,
    Color iconColor = lipContextColor,
    bool active = true,
    Key? key,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => active ? ontap() : {},
      key: key,
      color: iconColor,
    );
  }

  static Widget Function(BuildContext) fromPreset(DefaultAction preset) {
    return _defaultActionButtons[preset]!;
  }
}

enum DefaultAction {
  academy,
  bugreport,
  notification,
  filter,
  back,
  close,
  settings,
}

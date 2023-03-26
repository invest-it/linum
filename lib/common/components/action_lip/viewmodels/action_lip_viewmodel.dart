//  Action Lip Status Provider - Provider that handles behaviour of all current and future ActionLips GLOBALLY
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/navigation/get_delegate.dart';

class ActionLipViewModel extends ChangeNotifier {
  final Map<ScreenKey, ActionLipVisibility> _actionLipMap = {};
  final Map<ScreenKey, Widget> _actionBodyMap = {};
  final Map<ScreenKey, String> _actionTitleMap = {};

  void setActionLipStatus({
    required BuildContext context,
    required ScreenKey screenKey,
    required ActionLipVisibility status,
  }) {
    setActionLipStatusSilently(
      context: context,
      screenKey: screenKey,
      status: status,
    );
    notifyListeners();
  }

  void setActionLipStatusSilently({
    required BuildContext context,
    required ScreenKey screenKey,
    required ActionLipVisibility status,
  }) {
    if (status != ActionLipVisibility.onviewport) {
      context.getMainRouterDelegate().setOnPopOverwrite(null);
    }
    _actionLipMap[screenKey] = status;
  }

  void setActionLip({
    required BuildContext context,
    required ScreenKey screenKey,
    required Widget actionLipBody,
    String? actionLipTitle,
    ActionLipVisibility? actionLipStatus,
  }) {
    setActionLipSilently(
      screenKey: screenKey,
      actionLipBody: actionLipBody,
      actionLipStatus: actionLipStatus,
      actionLipTitle: actionLipTitle,
    );
    if (actionLipStatus == ActionLipVisibility.onviewport) {
      context.getMainRouterDelegate().setOnPopOverwrite(() {
        setActionLipStatus(
          context: context,
          screenKey: screenKey,
          status: ActionLipVisibility.hidden,
        );
      });
    }
    notifyListeners();
  }

  void setActionLipSilently({
    required ScreenKey screenKey,
    required Widget actionLipBody,
    String? actionLipTitle,
    ActionLipVisibility? actionLipStatus,
  }) {
    _actionBodyMap[screenKey] = actionLipBody;
    if (actionLipStatus != null) {
      _actionLipMap[screenKey] = actionLipStatus;
    }
    if (actionLipTitle != null) {
      _actionTitleMap[screenKey] = actionLipTitle;
    }
  }

  void setActionLipTitle({
    required ScreenKey screenKey,
    required String actionLipTitle,
  }) {
    _actionTitleMap[screenKey] = actionLipTitle;
    notifyListeners();
  }

  Widget getActionLipBody(ScreenKey screenKey) {
    return _actionBodyMap[screenKey] ??
        const Center(
          child: Text('Wrong key'),
        );
  }

  String getActionLipTitle(ScreenKey screenKey) {
    return _actionTitleMap[screenKey] ?? "Wrong key";
  }

  ActionLipVisibility getActionLipStatus(ScreenKey screenKey) {
    return _actionLipMap[screenKey] ?? ActionLipVisibility.disabled;
  }

  bool isActionStatusInitialized(ScreenKey screenKey) {
    return _actionLipMap[screenKey] != null;
  }

  bool isBodyInitialized(ScreenKey screenKey) {
    return _actionBodyMap[screenKey] != null;
  }

  bool isTitleInitialized(ScreenKey screenKey) {
    return _actionTitleMap[screenKey] != null;
  }
}

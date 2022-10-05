//  Action Lip Status Provider - Provider that handles behaviour of all current and future ActionLips GLOBALLY
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ActionLipStatusProvider extends ChangeNotifier {
  final Map<ProviderKey, ActionLipStatus> _actionLipMap = {};
  final Map<ProviderKey, Widget> _actionBodyMap = {};
  final Map<ProviderKey, String> _actionTitleMap = {};

  void setActionLipStatus({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.hidden,
  }) {
    setActionLipStatusSilently(
      providerKey: providerKey,
      actionLipStatus: actionLipStatus,
    );
    notifyListeners();
  }

  void setActionLipStatusSilently({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.hidden,
  }) {
    _actionLipMap[providerKey] = actionLipStatus;
  }

  void setActionLip({
    required ProviderKey providerKey,
    required Widget actionLipBody,
    String? actionLipTitle,
    ActionLipStatus? actionLipStatus,
  }) {
    setActionLipSilently(
      providerKey: providerKey,
      actionLipBody: actionLipBody,
      actionLipStatus: actionLipStatus,
      actionLipTitle: actionLipTitle,
    );
    notifyListeners();
  }

  void setActionLipSilently({
    required ProviderKey providerKey,
    required Widget actionLipBody,
    String? actionLipTitle,
    ActionLipStatus? actionLipStatus,
  }) {
    _actionBodyMap[providerKey] = actionLipBody;
    if (actionLipStatus != null) {
      _actionLipMap[providerKey] = actionLipStatus;
    }
    if (actionLipTitle != null) {
      _actionTitleMap[providerKey] = actionLipTitle;
    }
  }

  void setActionLipTitle({
    required ProviderKey providerKey,
    required String actionLipTitle,
  }) {
    _actionTitleMap[providerKey] = actionLipTitle;
    notifyListeners();
  }

  Widget getActionLipBody(ProviderKey providerKey) {
    return _actionBodyMap[providerKey] ??
        const Center(
          child: Text('Wrong key'),
        );
  }

  String getActionLipTitle(ProviderKey providerKey) {
    return _actionTitleMap[providerKey] ?? "Wrong key";
  }

  ActionLipStatus getActionLipStatus(ProviderKey providerKey) {
    return _actionLipMap[providerKey] ?? ActionLipStatus.disabled;
  }

  bool isActionStatusInitialized(ProviderKey providerKey) {
    return _actionLipMap[providerKey] != null;
  }

  bool isBodyInitialized(ProviderKey providerKey) {
    return _actionBodyMap[providerKey] != null;
  }

  bool isTitleInitialized(ProviderKey providerKey) {
    return _actionTitleMap[providerKey] != null;
  }

  static SingleChildWidget provider(
    BuildContext context, {
    bool testing = false,
  }) {
    return ChangeNotifierProvider<ActionLipStatusProvider>(
      create: (_) => ActionLipStatusProvider(),
    );
  }
}

enum ProviderKey {
  home,
  budget,
  stats,
  settings,
  onboarding,
  academy,
  enter,
  survey,
}

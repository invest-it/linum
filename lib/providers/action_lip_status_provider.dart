import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

class ActionLipStatusProvider extends ChangeNotifier {
  Map<ProviderKey, ActionLipStatus> _actionLipMap = {};
  Map<ProviderKey, Widget> _actionBodyMap = {};
  Map<ProviderKey, String> _actionTitleMap = {};

  void setActionLipStatus({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.HIDDEN,
  }) {
    _actionLipMap[providerKey] = actionLipStatus;
    notifyListeners();
  }

  void setActionLip({
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
    notifyListeners();
  }

  void setActionLipTitle(
      {required ProviderKey providerKey, required String actionLipTitle}) {
    _actionTitleMap[providerKey] = actionLipTitle;
    notifyListeners();
  }

  Widget getActionLipBody(ProviderKey providerKey) {
    return _actionBodyMap[providerKey] ??
        Center(
          child: Text('Wrong key'),
        );
  }

  String getActionLipTitle(ProviderKey providerKey) {
    return _actionTitleMap[providerKey] ?? "Wrong key";
  }

  ActionLipStatus getActionLipStatus(ProviderKey providerKey) {
    // TODO MVP set this to HIDDEN before deploying
    return _actionLipMap[providerKey] ?? ActionLipStatus.DISABLED;
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
}

enum ProviderKey {
  HOME,
  BUDGET,
  STATS,
  SETTINGS,
  ONBOARDING,
}

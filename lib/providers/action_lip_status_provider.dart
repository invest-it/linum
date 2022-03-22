import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

class ActionLipStatusProvider extends ChangeNotifier {
  final Map<ProviderKey, ActionLipStatus> _actionLipMap = {};
  final Map<ProviderKey, Widget> _actionBodyMap = {};
  final Map<ProviderKey, String> _actionTitleMap = {};

  void setActionLipStatus({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.HIDDEN,
  }) {
    setActionLipStatusSilently(
      providerKey: providerKey,
      actionLipStatus: actionLipStatus,
    );
    notifyListeners();
  }

  void setActionLipStatusSilently({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.HIDDEN,
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
  home,
  budget,
  stats,
  settings,
  onboarding,
  academy,
}

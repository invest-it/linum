import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';

class ActionLipStatusProvider extends ChangeNotifier {
  Map<ProviderKey, ActionLipStatus> _actionLipMap = {};
  Widget _actionLipBody = Column();

  void setActionLip({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.HIDDEN,
  }) {
    _actionLipMap[providerKey] = actionLipStatus;
    notifyListeners();
  }

  void setActionLipBody(Widget body) {
    _actionLipBody = body;
    notifyListeners();
  }

  ActionLipStatus getActionLipStatus(ProviderKey providerKey) {
    // TODO MVP set this to HIDDEN before deploying
    return _actionLipMap[providerKey] ?? ActionLipStatus.DISABLED;
  }

  bool isKeyInitialized(ProviderKey providerKey) {
    return _actionLipMap[providerKey] != null;
  }
}

enum ProviderKey {
  HOME,
  BUDGET,
  STATS,
  SETTINGS,
}

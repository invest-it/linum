import 'package:flutter/material.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class ActionLipStatusProvider extends ChangeNotifier {
  Map<ProviderKey, ActionLipStatus> _actionLipMap = {};
  Map<ProviderKey, Widget> _actionBodyMap = {};

  void setActionLip({
    required ProviderKey providerKey,
    ActionLipStatus actionLipStatus = ActionLipStatus.HIDDEN,
  }) {
    _actionLipMap[providerKey] = actionLipStatus;
    notifyListeners();
  }

  void setActionLipBody({
    required ProviderKey providerKey,
    required Widget actionLipBody,
  }) {
    _actionBodyMap[providerKey] = actionLipBody;
    notifyListeners();
  }

  Widget getActionLipBody(ProviderKey providerKey) {
    return _actionBodyMap[providerKey] ??
        Center(
          child: Text('Wrong key'),
        );
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
}

enum ProviderKey {
  HOME,
  BUDGET,
  STATS,
  SETTINGS,
}

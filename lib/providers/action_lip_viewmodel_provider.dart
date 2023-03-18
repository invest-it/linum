
import 'package:flutter/material.dart';
import 'package:linum/common/components/action_lip/viewmodels/action_lip_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ActionLipViewModelProvider extends SingleChildStatelessWidget {
  final bool testing;
  const ActionLipViewModelProvider({super.key, this.testing = false});

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProvider<ActionLipViewModel>(
      create: (_) => ActionLipViewModel(),
      child: child,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return build(context, child: child);
  }

}


import 'package:flutter/material.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AlgorithmServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  const AlgorithmServiceProvider({super.key, this.testing = false});

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProvider<AlgorithmService>(
      create: (_) => AlgorithmService(),
      lazy: false,
      child: child,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return build(context, child: child);
  }

}


import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:linum/core/balance/services/balance_data_service.dart';
import 'package:linum/features/currencies/services/exchange_rate_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class BalanceDataServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  const BalanceDataServiceProvider({super.key, this.testing = false});

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProxyProvider<AuthenticationService, BalanceDataService>(
      create: (ctx) {
        return BalanceDataService(context.read<AuthenticationService>().uid);
      },
      update: (ctx, auth, oldBalance) {
        if (oldBalance != null && oldBalance.userId == auth.uid) {
          return oldBalance;
        } else {
          return BalanceDataService(auth.uid);
        }
      },
      lazy: false,
      child: child,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return build(context, child: child);
  }

}

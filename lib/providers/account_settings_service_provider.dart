
import 'package:flutter/material.dart';
import 'package:linum/core/account/services/account_settings_service.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AccountSettingsServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  const AccountSettingsServiceProvider({
    super.key,
    this.testing = false,
  });

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProxyProvider<AuthenticationService,
        AccountSettingsService>(
      create: (ctx) {
        return AccountSettingsService(ctx);
      },
      update: (ctx, auth, oldAccountSettings) {
        if (oldAccountSettings != null) {
          return oldAccountSettings..updateAuth(auth, ctx);
        } else {
          return AccountSettingsService(ctx);
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

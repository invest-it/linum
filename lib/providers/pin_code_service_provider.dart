
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:linum/screens/lock_screen/services/pin_code_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PinCodeServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  const PinCodeServiceProvider({super.key, this.testing = false});

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProxyProvider<AuthenticationService, PinCodeService>(
      create: (context) => PinCodeService(context),
      update: (context, auth, oldPinCodeService) {
        if (oldPinCodeService == null) {
          return PinCodeService(context);
        } else {
          return oldPinCodeService..updateSipAndAuth(context);
        }
      },
      child: child,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return build(context, child: child);
  }

}

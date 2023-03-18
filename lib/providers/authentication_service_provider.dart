import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/authentication/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AuthenticationServiceProvider extends SingleChildStatelessWidget {
  final bool testing;
  const AuthenticationServiceProvider({super.key, this.testing = false});

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return ChangeNotifierProvider<AuthenticationService>(
      key: const Key("AuthenticationChangeNotifierProvider"),
      create: (_) {
        final AuthenticationService auth =
        AuthenticationService(FirebaseAuth.instance, context);
        if (testing) {
          auth.signOut();
          while (auth.isLoggedIn) {
            sleep(const Duration(milliseconds: 50));
            // this should only be called when we are testing.
          }
        }
        return auth;
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

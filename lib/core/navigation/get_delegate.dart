//  GetRouterDelegate Function
//  A shorthand for accessing the MainRouterDelegate via GetX
//
//  Author: damattl
//
//

import 'package:flutter/material.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';
import 'package:linum/core/navigation/main_routes.dart';

/// Finds an Instance of the MainRouterDelegate.
extension MainRouterDelegateAccessor on BuildContext {
  MainRouterDelegate getMainRouterDelegate() {
    return Router.of<MainRoute>(this).routerDelegate as MainRouterDelegate;
  }
}

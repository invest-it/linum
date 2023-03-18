//  GetRouterDelegate Function
//  A shorthand for accessing the MainRouterDelegate via GetX
//
//  Author: damattl
//
//

import 'package:get/get.dart';
import 'package:linum/core/navigation/main_router_delegate.dart';

/// Finds an Instance of the MainRouterDelegate.
/// Should only be called after GetX Initialization in app.dart
MainRouterDelegate getRouterDelegate() {
  return Get.find<MainRouterDelegate>();
}

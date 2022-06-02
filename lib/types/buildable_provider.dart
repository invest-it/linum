//  BuildableProvider - interface for provider-classes to be used in MultiProviderBuilder
//
//  Author: damattl
//

import 'package:flutter/material.dart';

abstract class BuildableProvider {
  static P buildProvider<P>(BuildContext context, {bool testing = false}) {
    // TODO: implement buildProvider
    throw UnimplementedError();
  }
}

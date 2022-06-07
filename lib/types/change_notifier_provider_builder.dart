//  ChangeNotifierProviderBuilder - typedef shorthand for the MultiProviderBuilder
//
//  Author: damattl
//

import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

typedef ChangeNotifierProviderBuilder = SingleChildWidget Function(BuildContext context, {bool testing});




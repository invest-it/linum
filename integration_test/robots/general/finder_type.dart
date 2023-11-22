//  Finder Type - A Robot File that can return certain element attributes by key.
//
//  Author: SoTBurst
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FinderType extends Finder {
  FinderType(this.finder, this.key);

  final Finder finder;
  final Key key;

  @override
  Iterable<Element> apply(Iterable<Element> candidates) {
    return finder.findInCandidates(candidates);
  }
  
  @override
  String get description => finder.describeMatch(Plurality.many);

  Finder get title => find.descendant(of: this, matching: find.byKey(key));
}

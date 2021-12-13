import 'package:flutter/material.dart';

abstract class AbstractStatisticPanel {
  addStatisticData(Map<String, dynamic> statisticalData);

  Widget get widget;
}

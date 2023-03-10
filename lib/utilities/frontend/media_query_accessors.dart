import 'package:flutter/material.dart';

Size useScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}
double useScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
double useScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
Orientation useDeviceOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation;
}
double useKeyBoardHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

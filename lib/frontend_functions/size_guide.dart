import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SizeGuide {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size

double proportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeGuide.screenHeight;
  // In Figma, we use 375 x 812 as the Design Canvas.
  // That's equivalent to an iPhone 11 Pro / iPhone X.

  // When using Screen Sizes from now on, call this function and hand over the
  // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
  // on EVERY device.
  return (inputHeight / 812.0) * screenHeight;
}

double proportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeGuide.screenWidth;
  // In Figma, we use 375 x 812 as the Design Canvas.
  // That's equivalent to an iPhone 11 Pro / iPhone X.

  // When using Screen Sizes from now on, call this function and hand over the
  // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
  // on EVERY device.
  return (inputWidth / 375.0) * screenWidth;
}

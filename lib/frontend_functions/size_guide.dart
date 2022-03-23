import 'package:flutter/material.dart';

class SizeGuide {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;
  static late bool keyboardIsOpened;
  static late double keyboardHeight;
  static const double referenceScreenWidth = 375.0;
  static const double referenceScreenHeight = 812.0;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    keyboardIsOpened = _mediaQueryData.viewInsets.bottom != 0.0;
    keyboardHeight = _mediaQueryData.viewInsets.bottom;
  }
}

// Get the proportionate height as per screen size
// USAGE:
// 1. Call the Init Function in the main Function of your file (this is already implemented, so please skip this and continue with step 2)
// e.g. "SizeGuide.init(context)"
//
// 2. Whenever you need widths or heights, always use the Functions provided
// e.g. for Width: "width: proportionateScreenWidth(275)" --> Returns 0.73334 per vw-pixel
// e.g. for height: "height: proportionateScreenHeight(406)" --> Returns 0.5000 per vh-pixel
//
//
// NEW!
// 3. If you want to specify a fraction of the screen, you can do so very comfortably by using the
// proportionateScreenWidthFraction / proportionateScreenHeightFraction functions in combination with the ScreenFraction enum.
//
// Example 1: You need half of the screen height
// height: proportionateScreenHeightFraction(ScreenFraction.HALF),
//
// Example 2: You need 66% (two thirds) of the screen width
// width: proportionateScreenWidthFraction(ScreenFraction.TWOTHIRDS),

double proportionateScreenHeight(double inputHeight) {
  final double screenHeight = SizeGuide.screenHeight;
  const double referenceScreenHeight = SizeGuide.referenceScreenHeight;
  // In Figma, we use 375 x 812 as the Design Canvas.
  // That's equivalent to an iPhone 11 Pro / iPhone X.

  // When using Screen Sizes from now on, call this function and hand over the
  // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
  // on EVERY device.
  return (inputHeight / referenceScreenHeight) * screenHeight;
}

double proportionateScreenHeightFraction(ScreenFraction inputFraction) {
  final double screenHeight = SizeGuide.screenHeight;
  const double referenceScreenHeight = SizeGuide.referenceScreenHeight;
  double scalingFactor;

  switch (inputFraction) {
    case ScreenFraction.full:
      scalingFactor = 1.0;
      break;
    case ScreenFraction.fourfiths:
      scalingFactor = 4 / 5;
      break;
    case ScreenFraction.threequearters:
      scalingFactor = 3 / 4;
      break;
    case ScreenFraction.twothirds:
      scalingFactor = 2 / 3;
      break;
    case ScreenFraction.threefifths:
      scalingFactor = 3 / 5;
      break;
    case ScreenFraction.half:
      scalingFactor = 1 / 2;
      break;
    case ScreenFraction.twofifths:
      scalingFactor = 2 / 5;
      break;
    case ScreenFraction.onethird:
      scalingFactor = 1 / 3;
      break;
    case ScreenFraction.onequarter:
      scalingFactor = 1 / 4;
      break;
    case ScreenFraction.onefifth:
      scalingFactor = 1 / 5;
      break;
    case ScreenFraction.onetenth:
      scalingFactor = 1 / 10;
      break;
    case ScreenFraction.quantile:
      scalingFactor = 1 / 100;
      break;
  }

  return ((scalingFactor * referenceScreenHeight) / referenceScreenHeight) *
      screenHeight;
}

double proportionateScreenWidthFraction(ScreenFraction inputFraction) {
  final double screenWidth = SizeGuide.screenWidth;
  const double referenceScreenWidth = SizeGuide.referenceScreenWidth;
  double scalingFactor;

  switch (inputFraction) {
    case ScreenFraction.full:
      scalingFactor = 1.0;
      break;
    case ScreenFraction.fourfiths:
      scalingFactor = 4 / 5;
      break;
    case ScreenFraction.threequearters:
      scalingFactor = 3 / 4;
      break;
    case ScreenFraction.twothirds:
      scalingFactor = 2 / 3;
      break;
    case ScreenFraction.threefifths:
      scalingFactor = 3 / 5;
      break;
    case ScreenFraction.half:
      scalingFactor = 1 / 2;
      break;
    case ScreenFraction.twofifths:
      scalingFactor = 2 / 5;
      break;
    case ScreenFraction.onethird:
      scalingFactor = 1 / 3;
      break;
    case ScreenFraction.onequarter:
      scalingFactor = 1 / 4;
      break;
    case ScreenFraction.onefifth:
      scalingFactor = 1 / 5;
      break;
    case ScreenFraction.onetenth:
      scalingFactor = 1 / 10;
      break;
    case ScreenFraction.quantile:
      scalingFactor = 1 / 100;
      break;
  }

  return ((scalingFactor * referenceScreenWidth) / referenceScreenWidth) *
      screenWidth;
}

double proportionateScreenWidth(double inputWidth) {
  final double screenWidth = SizeGuide.screenWidth;
  const double referenceScreenWidth = SizeGuide.referenceScreenWidth;
  // In Figma, we use 375 x 812 as the Design Canvas.
  // That's equivalent to an iPhone 11 Pro / iPhone X.

  // When using Screen Sizes from now on, call this function and hand over the
  // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
  // on EVERY device.
  return (inputWidth / referenceScreenWidth) * screenWidth;
}

double realScreenHeight() {
  return SizeGuide.screenHeight;
}

double realScreenWidth() {
  return SizeGuide.screenWidth;
}

enum ScreenFraction {
  ///100
  full,

  ///80%
  fourfiths,

  ///75%
  threequearters,

  ///67%
  twothirds,

  ///60%
  threefifths,

  ///50%
  half,

  ///40%
  twofifths,

  ///33%
  onethird,

  ///25%
  onequarter,

  ///20%
  onefifth,

  ///10%
  onetenth,

  ///1%
  quantile,
}

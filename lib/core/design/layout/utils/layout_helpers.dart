import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/constants/layout_reference.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';


extension LayoutHelpers on BuildContext {
  bool isKeyboardOpen() {
    return useKeyBoardHeight(this) != 0.0;
  }

// Get the proportionate height as per screen size
// USAGE:
// 1. Call the Init Function in the main Function of your file (this is already implemented, so please skip this and continue with step 2)
// e.g. "SizeGuideProvider.init(context)"
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
    // In Figma, we use 375 x 812 as the Design Canvas.
    // That's equivalent to an iPhone 11 Pro / iPhone X.

    // When using Screen Sizes from now on, call this function and hand over the
    // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
    // on EVERY device.
    return (inputHeight / LayoutReference.screenHeight) * useScreenHeight(this);
  }

  double proportionateScreenHeightFraction(ScreenFraction inputFraction) {
    double scalingFactor;

    switch (inputFraction) {
      case ScreenFraction.full:
        scalingFactor = 1.0;
      case ScreenFraction.fourfiths:
        scalingFactor = 4 / 5;
      case ScreenFraction.threequearters:
        scalingFactor = 3 / 4;
      case ScreenFraction.twothirds:
        scalingFactor = 2 / 3;
      case ScreenFraction.threefifths:
        scalingFactor = 3 / 5;
      case ScreenFraction.half:
        scalingFactor = 1 / 2;
      case ScreenFraction.twofifths:
        scalingFactor = 2 / 5;
      case ScreenFraction.onethird:
        scalingFactor = 1 / 3;
      case ScreenFraction.onequarter:
        scalingFactor = 1 / 4;
      case ScreenFraction.onefifth:
        scalingFactor = 1 / 5;
      case ScreenFraction.onetenth:
        scalingFactor = 1 / 10;
      case ScreenFraction.quantile:
        scalingFactor = 1 / 100;
    }

    return ((scalingFactor * LayoutReference.screenHeight) / LayoutReference.screenHeight) *
        useScreenHeight(this);
  }

  double proportionateScreenWidthFraction(ScreenFraction inputFraction) {
    double scalingFactor;

    switch (inputFraction) {
      case ScreenFraction.full:
        scalingFactor = 1.0;
      case ScreenFraction.fourfiths:
        scalingFactor = 4 / 5;
      case ScreenFraction.threequearters:
        scalingFactor = 3 / 4;
      case ScreenFraction.twothirds:
        scalingFactor = 2 / 3;
      case ScreenFraction.threefifths:
        scalingFactor = 3 / 5;
      case ScreenFraction.half:
        scalingFactor = 1 / 2;
      case ScreenFraction.twofifths:
        scalingFactor = 2 / 5;
      case ScreenFraction.onethird:
        scalingFactor = 1 / 3;
      case ScreenFraction.onequarter:
        scalingFactor = 1 / 4;
      case ScreenFraction.onefifth:
        scalingFactor = 1 / 5;
      case ScreenFraction.onetenth:
        scalingFactor = 1 / 10;
      case ScreenFraction.quantile:
        scalingFactor = 1 / 100;
    }

    return ((scalingFactor * LayoutReference.screenWidth) / LayoutReference.screenWidth) *
        useScreenWidth(this);
  }

  double proportionateScreenWidth(double inputWidth) {
    // In Figma, we use 375 x 812 as the Design Canvas.
    // That's equivalent to an iPhone 11 Pro / iPhone X.

    // When using Screen Sizes from now on, call this function and hand over the
    // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
    // on EVERY device.
    return (inputWidth / LayoutReference.screenWidth) * useScreenWidth(this);
  }


  // The Iphone 15 Pro Max has an defaultWidth of 430.0
  double scaledFontSize(double fontSize, {double defaultWidth = 430.0}) {
    final screenWidth = MediaQuery.of(this).size.width;

    final ratio = screenWidth / defaultWidth;

    return fontSize * ratio;
  }
}

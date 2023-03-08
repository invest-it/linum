import 'package:flutter/material.dart';
import 'package:linum/types/change_notifier_provider_builder.dart';
import 'package:provider/provider.dart';

class SizeGuideProvider extends ChangeNotifier {
  late BuildContext _context;

  MediaQueryData get _mediaQueryData => MediaQuery.of(_context);

  static const double referenceScreenWidth = 375.0;
  static const double referenceScreenHeight = 812.0;

  double get screenWidth => _mediaQueryData.size.width;
  double get screenHeight => _mediaQueryData.size.height;
  Orientation get orientation => _mediaQueryData.orientation;

  double get keyboardHeight => _mediaQueryData.viewInsets.bottom;

  SizeGuideProvider(BuildContext context) {
    _context = context;
  }

  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom != 0.0;
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
    const double referenceScreenHeight =
        SizeGuideProvider.referenceScreenHeight;
    // In Figma, we use 375 x 812 as the Design Canvas.
    // That's equivalent to an iPhone 11 Pro / iPhone X.

    // When using Screen Sizes from now on, call this function and hand over the
    // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
    // on EVERY device.
    return (inputHeight / referenceScreenHeight) * screenHeight;
  }

  double proportionateScreenHeightFraction(ScreenFraction inputFraction) {
    const double referenceScreenHeight =
        SizeGuideProvider.referenceScreenHeight;
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
    const double referenceScreenWidth = SizeGuideProvider.referenceScreenWidth;
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
    const double referenceScreenWidth = SizeGuideProvider.referenceScreenWidth;
    // In Figma, we use 375 x 812 as the Design Canvas.
    // That's equivalent to an iPhone 11 Pro / iPhone X.

    // When using Screen Sizes from now on, call this function and hand over the
    // sizes as declared in the Figma Mockup. This way, the sizes will scale correctly
    // on EVERY device.
    return (inputWidth / referenceScreenWidth) * screenWidth;
  }

// TODO: redundant
  double realScreenHeight() {
    return screenHeight;
  }

// TODO: redundant
  double realScreenWidth() {
    return screenWidth;
  }

  static ChangeNotifierProviderBuilder builder() {
    return (BuildContext context, {bool testing = false}) {
      return ChangeNotifierProvider<SizeGuideProvider>(
        create: (ctx) => SizeGuideProvider(ctx),
        lazy: false,
      );
    };
  }

  /// Call when you know data has changed (or you worry it might have)
  void update() {
    notifyListeners();
  }
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

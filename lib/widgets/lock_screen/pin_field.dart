//  PIN Field - Collection of Numeric Field (Numpad) used for the PIN lock
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//

import 'package:flutter/material.dart';
import 'package:linum/providers/size_guide_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:provider/provider.dart';

class PinField extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Color ringColor;
  const PinField(this.index, this.selectedIndex, this.ringColor, {super.key});

  @override
  Widget build(BuildContext context) {
    final sizeGuideProvider =
        Provider.of<SizeGuideProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: sizeGuideProvider
                .proportionateScreenWidthFraction(ScreenFraction.quantile) *
            2,
      ),
      width: sizeGuideProvider.proportionateScreenWidth(50),
      height: sizeGuideProvider.proportionateScreenWidth(50),
      decoration: BoxDecoration(
        color: selectedIndex >= index
            ? Theme.of(context).colorScheme.tertiary
            : Theme.of(context).colorScheme.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(96),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: selectedIndex == index - 1
                ? ringColor
                : Colors.black.withAlpha(0), // no color
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

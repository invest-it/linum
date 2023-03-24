import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';

class EnterScreenScaffold extends StatelessWidget {
  final Widget body;
  final double bodyHeight;
  final double bodyWidth;
  const EnterScreenScaffold({
    super.key, 
    required this.body,
    this.bodyHeight = double.maxFinite,
    this.bodyWidth = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.proportionateScreenHeightFraction(ScreenFraction.threefifths),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
              ),
            ),
            Container(
              height: bodyHeight,
              width: bodyWidth,
              color: Colors.white,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';

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
    const radius = Radius.circular(16.0);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.proportionateScreenHeightFraction(ScreenFraction.threefifths) + useKeyBoardHeight(context),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
              ),
              height: bodyHeight,
              width: bodyWidth,
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}

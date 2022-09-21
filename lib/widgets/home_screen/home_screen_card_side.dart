//  Home Screen Card Side - General Class for Layouting of one side of the HomeSceenCard
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:linum/models/home_screen_card_data.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/home_screen/home_screen_card_arrow.dart';
import 'package:linum/widgets/home_screen/home_screen_card_bottom_row.dart';

class HomeScreenCardSide extends StatelessWidget {
  final FlipCardController flipCardController;
  final HomeScreenCardData data;
  final Text headline;
  final Text subHeadline;
  final Row middleRow;
  final HomeScreenCardArrow upwardArrow;
  final HomeScreenCardArrow downwardArrow;
  final bool isBack;
  const HomeScreenCardSide({
    super.key,
    required this.flipCardController,
    required this.data,
    required this.headline,
    required this.subHeadline,
    required this.middleRow,
    required this.upwardArrow,
    required this.downwardArrow,
    required this.isBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TODO look at this
        // ignore: use_decorated_box
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(64),
                blurRadius: 16.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/v01-cubes-12.png"),
                    opacity: 0.6,
                    fit: BoxFit.cover,
                  ),
                ),
                width: proportionateScreenWidth(345),
                height: proportionateScreenHeight(196),
                // color: Colors.grey[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Center(
                              child: headline,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  padding: const EdgeInsets.only(right: 16),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    flipCardController.toggleCard();
                                  },
                                  icon: const Icon(
                                    Icons.flip_camera_android_rounded,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subHeadline
                      ],
                    ),
                    middleRow,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: HomeScreenCardBottomRow(
                        data: data,
                        upwardArrow: upwardArrow,
                        downwardArrow: downwardArrow,
                        isBack: isBack,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

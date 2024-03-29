//  Single Slide - One Slide of the Onboarding Screen (used in the PageView) - consisting of an SVG, a title and a description.
//
//  Author: NightmindOfficial
//  Co-Author: n/a
//  (Refactored by damattl)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/navigation/url_handler.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/models/onboarding_slide_data.dart';




class SingleSlide extends StatefulWidget {
  const SingleSlide({super.key, required this.slide});

  final OnboardingSlideData slide;

  @override
  State<SingleSlide> createState() => _SingleSlideState();
}

class _SingleSlideState extends State<SingleSlide> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              top: context.proportionateScreenHeight(24),
            ),
            child: CupertinoButton(
              child: Text(
                tr(translationKeys.onboardingScreen.svgCreditLabel),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onPressed: () => {
                launchURL(widget.slide.freepikURL),
              },
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(32),
            child: SvgPicture.asset(widget.slide.imageURL),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            tr(widget.slide.heading),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        widget.slide.description != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                child: Text(
                  tr(widget.slide.description!),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              )
            : const Padding(
                padding: EdgeInsets.zero,
              ),
        SizedBox(
          height: context.proportionateScreenHeight(230),
        ),
      ],
    );

    // what to do on page change?
  }
}

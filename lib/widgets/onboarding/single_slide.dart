import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/url_handler.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/models/onboarding_slide_data.dart';

class SingleSlide extends StatefulWidget {
  const SingleSlide({Key? key, required this.slide}) : super(key: key);

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
              top: proportionateScreenHeight(24),
            ),
            child: CupertinoButton(
              child: Text(
                AppLocalizations.of(context)!
                    .translate('onboarding_screen/svg-credit-label'),
                style: Theme.of(context).textTheme.caption,
              ),
              onPressed: () => {
                launchURL(widget.slide.freepikURL)
                    .then((value) => log(value.toString())),
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
            AppLocalizations.of(context)!.translate(widget.slide.heading),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        widget.slide.description != null
            ? Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            AppLocalizations.of(context)!.translate(widget.slide.description!),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        )
            : const Padding(
          padding: EdgeInsets.zero,
        ),
        SizedBox(
          height: proportionateScreenHeight(230),
        )
      ],
    );

    // what to do on page change?
  }
}

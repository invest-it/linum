//  Academy Screen - Mostly "aesthetic-focused" depiction of the linkage to the Invest it! YT Channel
//
//  Author: NightmindOfficial
//  Co-Author: n/a
/// PAGE INDEX 4

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linum/providers/screen_index_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/backend/url_handler.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/screen_skeleton/app_bar_action.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

/// Page Index: 4
class AcademyScreen extends StatelessWidget {
  const AcademyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenIndexProvider screenIndexProvider =
        Provider.of<ScreenIndexProvider>(context);

    return ScreenSkeleton(
      head: 'Academy',
      leadingAction: (BuildContext context) => AppBarAction.fromParameters(
        icon: Icons.arrow_back_rounded,
        ontap: () => screenIndexProvider.setPageIndex(0),
      ),
      isInverted: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height:
                  proportionateScreenHeightFraction(ScreenFraction.onequarter),
              child: SvgPicture.asset('assets/svg/video-files.svg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                AppLocalizations.of(context)!
                    .translate('academy_screen/label-title'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                AppLocalizations.of(context)!
                    .translate('academy_screen/label-description'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 12,
                    children: [
                      const Icon(Icons.open_in_new_rounded),
                      Text(
                        AppLocalizations.of(context)!
                            .translate("academy_screen/label-button"),
                      ),
                    ],
                  ),
                ),
                onPressed: () => launchURL(
                  'https://www.youtube.com/channel/UCuOMXn1kbzCOssokM-K9XjA',
                ), //Currently, youtube.investit-academy.de and yt.investit-academy.de are not resolving.
              ),
            ),
            // SizedBox(
            //   height: proportionateScreenHeight(230),
            // ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!
                      .translate('onboarding_screen/svg-credit-label'),
                  style: Theme.of(context).textTheme.caption,
                ),
                onPressed: () => {
                  launchURL('https://storyset.com/technology')
                      .then((value) => log(value.toString())),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

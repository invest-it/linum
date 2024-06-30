//  Academy Screen - Mostly "aesthetic-focused" depiction of the linkage to the Invest it! YT Channel
//
//  Author: NightmindOfficial
//  Co-Author: n/a
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/app_bar_action.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/core/navigation/get_delegate.dart';
import 'package:linum/core/navigation/url_handler.dart';
import 'package:linum/generated/translation_keys.g.dart';

/// Page Index: 4
class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSkeleton(
      head: 'YouTube',
      leadingAction: (BuildContext context) => AppBarAction.fromParameters(
        icon: Icons.arrow_back_rounded,
        ontap: () => context.getMainRouterDelegate().popRoute(),
        // TODO: Maybe use another method, animation does not look good.
      ),
      isInverted: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context
                  .proportionateScreenHeightFraction(ScreenFraction.onequarter),
              child: SvgPicture.asset('assets/svg/video-files.svg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                tr(translationKeys.academyScreen.labelTitle),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                tr(translationKeys.academyScreen.labelDescription),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
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
                      Text(tr(translationKeys.academyScreen.labelButton)),
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
                  tr(translationKeys.onboardingScreen.svgCreditLabel),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onPressed: () => {
                  launchURL('https://storyset.com/technology'),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

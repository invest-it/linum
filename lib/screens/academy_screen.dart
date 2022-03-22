import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/url_handler.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/screen_index_provider.dart';
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
      body: Column(
        children: [
          Container(
            height:
                proportionateScreenHeightFraction(ScreenFraction.onequarter),
            margin: const EdgeInsets.all(32),
            child: SvgPicture.asset('assets/svg/video-files.svg'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Text(
              AppLocalizations.of(context)!
                  .translate('academy_screen/label-title'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: Text(
              AppLocalizations.of(context)!
                  .translate('academy_screen/label-description'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 12,
                  children: const [
                    Icon(Icons.open_in_new_rounded),
                    Text("Zum YouTube-Kanal"),
                  ],
                ),
              ),
              onPressed: () => launchURL('https://youtube.investit-academy.de'),
            ),
          ),
          // SizedBox(
          //   height: proportionateScreenHeight(230),
          // ),
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
                  launchURL('https://storyset.com/technology')
                      .then((value) => log(value.toString())),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

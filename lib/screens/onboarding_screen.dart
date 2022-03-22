import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/backend_functions/url_handler.dart';
import 'package:linum/frontend_functions/country_flag_generator.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/silent_scroll.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/providers/onboarding_screen_provider.dart';
import 'package:linum/widgets/auth/login_form.dart';
import 'package:linum/widgets/auth/register_form.dart';
import 'package:linum/widgets/onboarding/onboarding_slide.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingPage> {
// create all assets before drawing the screen

  int _currentPage = 0;
  List<OnboardingSlide> _slides = [];
  late PageController _pageController = PageController();

  @override
  void initState() {
    _currentPage = 0;
    _slides = [
      OnboardingSlide(
        imageURL: 'assets/svg/mobile-login.svg',
        heading: 'onboarding_screen/card1-title',
        freepikURL: 'https://storyset.com/phone',
        description: 'onboarding_screen/card1-description',
      ),
      OnboardingSlide(
        imageURL: 'assets/svg/refund.svg',
        heading: 'onboarding_screen/card2-title',
        freepikURL: 'https://storyset.com/device',
        description: 'onboarding_screen/card2-description',
      ),
      OnboardingSlide(
        imageURL: 'assets/svg/video-files.svg',
        heading: 'onboarding_screen/card3-title',
        description: 'onboarding_screen/card3-description',
        freepikURL: 'https://storyset.com/technology',
      ),
      OnboardingSlide(
        imageURL: 'assets/svg/financial-data.svg',
        heading: 'onboarding_screen/card4-title',
        description: 'onboarding_screen/card4-description',
        freepikURL: 'https://storyset.com/data',
      ),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  // List for all OnboardingSlides build with the OnboardingSlide class
  List<Widget> _builtSlides() {
    return _slides.map(_createSingleSlide).toList();
  }

  Widget _createSingleSlide(OnboardingSlide slide) {
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
                launchURL(slide.freepikURL)
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
            child: SvgPicture.asset(slide.imageURL),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            AppLocalizations.of(context)!.translate(slide.heading),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        slide.description != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate(slide.description as String),
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
  }
  // what to do on page change?

  void _handleOnPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

// responsive page indicator
  Widget _buildPageIndicator() {
    final Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
    );

    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1) {
        row.children.add(
          const SizedBox(
            width: 12,
          ),
        );
      }
    }

    return row;
  }

  // defines the style of one single page indicator
  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 8 : 5,
      height: index == _currentPage ? 8 : 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _loginWidth = 0;

  double _loginOpacity = 1;
  double windowWidth = realScreenWidth();
  double windowHeight = realScreenHeight();

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenProvider onboardingScreenProvider =
        Provider.of<OnboardingScreenProvider>(
      context,
    );

    switch (onboardingScreenProvider.pageState) {
      case 0:
        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case 1:
        _loginYOffset = SizeGuide.keyboardIsOpened
            ? proportionateScreenHeightFraction(ScreenFraction.twofifths) -
                (SizeGuide.keyboardHeight / 2)
            : proportionateScreenHeightFraction(ScreenFraction.twofifths);
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case 2:
        _loginYOffset = SizeGuide.keyboardIsOpened
            ? proportionateScreenHeightFraction(ScreenFraction.twofifths) -
                (SizeGuide.keyboardHeight / 2) -
                32
            : proportionateScreenHeightFraction(ScreenFraction.twofifths) - 32;
        _registerYOffset = SizeGuide.keyboardIsOpened
            ? proportionateScreenHeightFraction(ScreenFraction.twofifths) -
                (SizeGuide.keyboardHeight / 2)
            : proportionateScreenHeightFraction(ScreenFraction.twofifths);
        _loginXOffset = 20;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.80;
    }

    return ScreenSkeleton(
      head: '', // will not be displayed anyways
      contentOverride: true,
      providerKey: ProviderKey.onboarding,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onboardingScreenProvider.setPageState(0);
        },
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: SilentScroll(),
              child: PageView(
                controller: _pageController,
                onPageChanged: _handleOnPageChanged,
                physics: const PageScrollPhysics(),
                children: [
                  ..._builtSlides(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    elevation: 1,
                    items: <String>[
                      countryFlag('de'),
                      countryFlag('gb'),
                      countryFlag('nl'),
                      countryFlag('es'),
                      countryFlag('fr'),
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: countryFlagWithSpecialCases(
                      AppLocalizations.of(context)!.locale.languageCode,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          final Map<String, String> countryFlagsToCountryCode =
                              {
                            countryFlag('de'): "de",
                            countryFlag('gb'): "en",
                            countryFlag('nl'): "nl",
                            countryFlag('es'): "es",
                            countryFlag('fr'): "fr",
                          };
                          SharedPreferences.getInstance().then((pref) {
                            pref.setString(
                              "languageCode",
                              countryFlagsToCountryCode[value] ?? "en",
                            );
                          });
                          final String langString =
                              countryFlagsToCountryCode[value] ?? "en";
                          AppLocalizations.of(context)!.load(
                            locale: Locale(
                              langString,
                              langString != "en"
                                  ? langString.toUpperCase()
                                  : "US",
                            ),
                          );

                          Provider.of<AuthenticationService>(
                            context,
                            listen: false,
                          ).updateLanguageCode(context);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  _buildPageIndicator(),
                  SizedBox(
                    height: proportionateScreenHeight(32),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        callback: () => {
                          onboardingScreenProvider.setPageState(2),
                        },
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            createMaterialColor(const Color(0xFFC1E695)),
                          ],
                        ),
                        elevation: 0,
                        increaseHeightBy: proportionateScreenHeight(56 - 24),
                        increaseWidthBy: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate('onboarding_screen/register-button'),
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: proportionateScreenHeight(10),
                  ),
                  CupertinoButton(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('onboarding_screen/login-button'),
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    onPressed: () => {
                      onboardingScreenProvider.setPageState(1),
                    },
                  ),
                ],
              ),
            ),

            // Auth Screens

            GestureDetector(
              onTap: () {
                onboardingScreenProvider.setPageState(1);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: AnimatedContainer(
                width: _loginWidth,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 1200),
                transform:
                    Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(_loginOpacity),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(
                            onboardingScreenProvider.pageState == 0 ? 0 : 135,
                          ),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        AnimatedSize(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: const Duration(milliseconds: 800),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: onboardingScreenProvider.pageState == 2
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                              topRight: onboardingScreenProvider.pageState == 2
                                  ? const Radius.circular(32)
                                  : Radius.zero,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: onboardingScreenProvider.pageState == 2
                                  ? 32 * 1.2
                                  : 0,
                              color: Theme.of(context).colorScheme.primary,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate(
                                        'onboarding_screen/cta-login',
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //CONTENTS OF LOGIN HERE
                        LoginForm(),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: SizeGuide.keyboardIsOpened
                          ? 0
                          : proportionateScreenHeightFraction(
                              ScreenFraction.twofifths,
                            ),
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            onboardingScreenProvider.setPageState(2);
                          },
                          child: Container(
                            width: double.infinity,
                            height: proportionateScreenHeight(42),
                            color: Theme.of(context).colorScheme.primary,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      'onboarding_screen/cta-register',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onboardingScreenProvider.setPageState(2);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 800),
                transform: Matrix4.translationValues(0, _registerYOffset, 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.onSurface.withAlpha(80),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // CONTENTS OF REGISTER HERE
                        RegisterForm(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/url-handler.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/onboarding/onboarding_slide.dart';

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
          heading: 'Herzlich willkommen!',
          freepikURL: 'https://storyset.com/phone',
          description: 'Dein neuer Budgeting-Assistent wartet schon auf dich.'),
      OnboardingSlide(
        imageURL: 'assets/svg/refund.svg',
        heading: 'Tracke dein Geld',
        freepikURL: 'https://storyset.com/device',
        description:
            'So einfach war\'s noch nie: Mit unserer Tracking-Funktion weißt du immer genau, wie viel Geld du gerade hast.',
      ),
      OnboardingSlide(
        imageURL: 'assets/svg/video-files.svg',
        heading: 'Sei bestens vorbereitet',
        description:
            'Über unser Academy-Feature bekommst du eine große Auswahl an kostenlosen Videos zu vielen Themen aus der Finanzwelt!',
        freepikURL: 'https://storyset.com/technology',
      ),
      OnboardingSlide(
        imageURL: 'assets/svg/financial-data.svg',
        heading: 'Behalte den Überblick',
        description:
            'Linum generiert ganz automatisch relevante Statistiken für dich. So kannst du nachvollziehen, wie du mit deinem Budget umgehst.',
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
        Container(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              top: proportionateScreenHeight(16),
            ),
            child: CupertinoButton(
              child: Text(
                'Illustrations by Freepik',
                style: Theme.of(context).textTheme.overline,
              ),
              onPressed: () => {},
              // onPressed: launchURL(slide.freepikURL),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(32),
            child: SvgPicture.asset(slide.imageURL),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            slide.heading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        slide.description != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                child: Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              )
            : Padding(
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
    Row row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [],
    );

    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1) {
        row.children.add(SizedBox(
          width: 12,
        ));
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
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.onError,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _handleOnPageChanged,
            // For now, standard physics will do the trick. TODO-FUTURE improve the looks of this
            physics: PageScrollPhysics(),
            children: [
              ..._builtSlides(),
            ],
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
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      child: Text(
                        'Jetzt registrieren!',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      callback: () => {},
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          createMaterialColor(Color(0xFFC1E695)),
                        ],
                      ),
                      elevation: 0,
                      increaseHeightBy: proportionateScreenHeight(56 - 24),
                      increaseWidthBy: double.infinity,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                SizedBox(
                  height: proportionateScreenHeight(10),
                ),
                CupertinoButton(
                    child: Text(
                      'Ich habe einen Account',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    onPressed: () => {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

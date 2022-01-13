import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:linum/backend_functions/url-handler.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:linum/widgets/onboarding/onboarding_slide.dart';
import 'package:provider/provider.dart';

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
              onPressed: () => {
                launchURL(slide.freepikURL)
                    .then((value) => log(value.toString())),
              },
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
            ? Theme.of(context).colorScheme.primaryVariant
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // States: 0 = normal onboarding, 1 = login page, 2 = register page
  int _pageState = 0;

  // hides developer login bypasses
  // TODO BEFORE MVP REMOVE THIS FFS!
  int devMode = 0;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _loginWidth = 0;

  double _loginOpacity = 1;
  double windowWidth = realScreenWidth();
  double windowHeight = realScreenHeight();

  final _mailController = TextEditingController();
  final _passController = TextEditingController();
  late final Function logIn;

  @override
  Widget build(BuildContext context) {
    AuthenticationService auth = Provider.of<AuthenticationService>(context);

    switch (_pageState) {
      case 0:
        _loginYOffset = windowHeight;
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case 1:
        _loginYOffset = 200;
        _registerYOffset = windowHeight;
        _loginXOffset = 0;
        _loginWidth = windowWidth;
        _loginOpacity = 1;
        break;
      case 2:
        _loginYOffset = 170;
        _registerYOffset = 200;
        _loginXOffset = 20;
        _loginWidth = windowWidth - 40;
        _loginOpacity = 0.80;
    }

    void logIn(String _mail, String _pass) {
      auth
          .signIn(
            _mail,
            _pass,
          )
          .then(
            (value) => log("login status: " + value),
          );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () => setState(() {
          _pageState = 0;
        }),
        child: Stack(
          children: [
            // TODO Add the Silent Scroll Handler here -
            // I was too lazy to stash the thing I was working on when I thought about this
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
                          style: Theme.of(context).textTheme.button,
                        ),
                        callback: () => {
                          setState(() {
                            _pageState = 2;
                          })
                        },
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
                      onPressed: () => {
                            setState(() {
                              _pageState = 1;
                            })
                          }),
                ],
              ),
            ),

// Auth Screens

            GestureDetector(
              onTap: () => setState(() {
                _pageState = 1;
              }),
              child: AnimatedContainer(
                width: _loginWidth,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 600),
                transform:
                    Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(_loginOpacity),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(_pageState == 0 ? 0 : 135),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedSize(
                          curve: Curves.fastLinearToSlowEaseIn,
                          duration: Duration(milliseconds: 800),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: _pageState == 2
                                  ? Radius.circular(32)
                                  : Radius.circular(0),
                              topRight: _pageState == 2
                                  ? Radius.circular(32)
                                  : Radius.circular(0),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: _pageState == 2 ? 32 * 1.2 : 0,
                              color: Theme.of(context).colorScheme.primary,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        'Du hast einen Account? Hier einloggen',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),

                        //CONTENTS OF LOGIN HERE

                        devMode >= 6
                            ? Wrap(
                                spacing: 8,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.zero,
                                      primary:
                                          Theme.of(context).colorScheme.onError,
                                    ),
                                    onPressed: () => {
                                      auth
                                          .signIn(
                                              "Soencke.Evers@investit-academy.de",
                                              "tempPassword123")
                                          .then(
                                            (value) =>
                                                log("login status: " + value),
                                          ),
                                    },
                                    child: Text(
                                      'Perform Normal Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        primary: Theme.of(context)
                                            .colorScheme
                                            .error),
                                    onPressed: () => {
                                      auth
                                          .signIn(
                                              "linum.debug@investit-academy.de",
                                              "F8q^5w!F9S4#!")
                                          .then(
                                            (value) =>
                                                log("login status: " + value),
                                          ),
                                    },
                                    child: Text(
                                      'Perform Stress Test',
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                    ),
                                  ),
                                ],
                              )
                            : Wrap(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "LOGIN",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10),
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade100),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _mailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "E-Mail-Adresse",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade100),
                                        ),
                                      ),
                                      child: TextField(
                                        obscureText: true,
                                        controller: _passController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        onSubmitted: (_) => {
                                          setState(
                                            () {
                                              logIn(_mailController.text,
                                                  _passController.text);
                                            },
                                          )
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Passwort",
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: proportionateScreenHeight(32),
                              ),
                              // Container(
                              //   height: 50,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(10),
                              //     gradient: LinearGradient(
                              //       colors: [
                              //         Theme.of(context).colorScheme.primary,
                              //         Theme.of(context).colorScheme.surface,
                              //       ],
                              //     ),
                              //   ),
                              //   child: Center(
                              //     child: Text(
                              //       'Einloggen',
                              //       style: Theme.of(context).textTheme.button,
                              //     ),
                              //   ),
                              // ),

                              GradientButton(
                                increaseHeightBy: proportionateScreenHeight(16),
                                child: Text(
                                  'Anmelden',
                                  style: Theme.of(context).textTheme.button,
                                ),
                                callback: () => {
                                  setState(
                                    () {
                                      logIn(_mailController.text,
                                          _passController.text);
                                    },
                                  )
                                },
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    createMaterialColor(Color(0xFFC1E695)),
                                  ],
                                ),
                                elevation: 0,
                                increaseWidthBy: double.infinity,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              SizedBox(
                                height: proportionateScreenHeight(8),
                              ),
                              OutlinedButton(
                                //TODO implement this functionality
                                onPressed: null,
                                child: Text(
                                  'Passwort vergessen?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                ),
                                style: OutlinedButton.styleFrom(
                                  elevation: 8,
                                  shadowColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  minimumSize: Size(
                                    double.infinity,
                                    proportionateScreenHeight(64),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  side: BorderSide(
                                    width: 2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              IconButton(
                                color: Colors.grey.shade200,
                                onPressed: () {
                                  setState(() {
                                    devMode++;
                                    log(
                                      devMode < 6
                                          ? 'OK, in ' +
                                              (6 - devMode).toString() +
                                              ' Schritten bist du Entwickler.'
                                          : 'OK, du bist nun Entwickler.',
                                    );
                                  });
                                },
                                icon: Icon(Icons.developer_board_rounded),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      bottom: 200,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pageState = 2;
                            });
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
                                      'Noch keinen Account? Hier registrieren',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() {
                _pageState = 1;
              }),
              child: AnimatedContainer(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 800),
                  transform: Matrix4.translationValues(0, _registerYOffset, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(80),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('I am the register page! Work in Progress.'),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

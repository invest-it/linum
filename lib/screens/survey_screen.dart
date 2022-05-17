import 'dart:math';

import 'package:flutter/material.dart';
import 'package:linum/widgets/settings_screen/survey_button.dart';

import '../utilities/frontend/size_guide.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/survey_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(
                "Umfrage",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top:
                    // proportionateScreenHeightFraction(
                    //   ScreenFraction.twofifths,
                    // ),
                    24,
              ),
              child: SizedBox(
                height: proportionateScreenHeightFraction(
                  ScreenFraction.twofifths,
                ),
                child: Image.asset("assets/images/question_mark.jpg"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Hilf uns, Deine App noch besser zu machen!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            //Button fehlt noch
          ],
        ),
      ),
    );
  }
}

//  Onboarding Screen - Screen that is displayed the FirebaseAuth has no User Credentials (when there is no user logged in)
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/onboarding_page.dart';
import 'package:provider/provider.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingScreenViewModel>(
        create: (_) => OnboardingScreenViewModel(),
        child: const OnboardingPage(),
    );
  }
}

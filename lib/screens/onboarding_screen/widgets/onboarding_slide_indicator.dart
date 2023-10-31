import 'package:flutter/material.dart';
import 'package:linum/common/widgets/page_indicator.dart';
import 'package:linum/screens/onboarding_screen/constants/onboarding_slides.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class OnboardingSlideIndicator extends StatelessWidget {
  const OnboardingSlideIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingScreenViewModel>();
    return PageIndicator(
      slideCount: onboardingSlides.length,
      currentSlide: viewModel.currentSlide,
    );
  }
}

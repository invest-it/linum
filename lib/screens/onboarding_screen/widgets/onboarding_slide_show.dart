import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/screens/onboarding_screen/constants/onboarding_slides.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/single_slide.dart';
import 'package:provider/provider.dart';

class OnboardingSlideShow extends StatelessWidget {
  const OnboardingSlideShow({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<OnboardingScreenViewModel>();
    return ScrollConfiguration(
      behavior: SilentScroll(),
      child: PageView(
        controller: viewModel.slideController,
        physics: const PageScrollPhysics(),
        onPageChanged: (slide) {
          viewModel.currentSlide = slide;
        },
        children: [
          ..._buildSlides(),
        ],
      ),
    );
  }

  // List for all OnboardingSlides build with the OnboardingSlide class
  List<Widget> _buildSlides() {
    return onboardingSlides.map((slide) => SingleSlide(slide: slide)).toList();
  }
}

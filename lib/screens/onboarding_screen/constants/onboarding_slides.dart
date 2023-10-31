import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/onboarding_screen/models/onboarding_slide_data.dart';

final onboardingSlides = List<OnboardingSlideData>.unmodifiable([
  OnboardingSlideData(
    imageURL: 'assets/svg/mobile-login.svg',
    heading: translationKeys.onboardingScreen.card1Title,
    freepikURL: 'https://storyset.com/phone',
    description: translationKeys.onboardingScreen.card1Description,
  ),
  OnboardingSlideData(
    imageURL: 'assets/svg/refund.svg',
    heading: translationKeys.onboardingScreen.card2Title,
    freepikURL: 'https://storyset.com/device',
    description: translationKeys.onboardingScreen.card2Description,
  ),
  OnboardingSlideData(
    imageURL: 'assets/svg/video-files.svg',
    heading: translationKeys.onboardingScreen.card3Title,
    description: translationKeys.onboardingScreen.card3Description,
    freepikURL: 'https://storyset.com/technology',
  ),
  OnboardingSlideData(
    imageURL: 'assets/svg/financial-data.svg',
    heading: translationKeys.onboardingScreen.card4Title,
    description: translationKeys.onboardingScreen.card4Description,
    freepikURL: 'https://storyset.com/data',
  ),
]);

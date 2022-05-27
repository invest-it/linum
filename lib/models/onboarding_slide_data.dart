//  OnboardingSlideData - Model for defining contents of a single Onboarding Slide
//
//  Author: NightmindOfficial
//  Co-Author: damattl
//  (Refactored)

class OnboardingSlideData {
  String imageURL;
  String heading;
  String freepikURL;
  String? description;

  OnboardingSlideData({
    required this.imageURL,
    required this.heading,
    required this.freepikURL,
    this.description,
  });
}

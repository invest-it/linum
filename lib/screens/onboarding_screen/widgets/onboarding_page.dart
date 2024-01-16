import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_key.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/widgets/screen_skeleton.dart';
import 'package:linum/screens/onboarding_screen/enums/onboarding_page_state.dart';
import 'package:linum/screens/onboarding_screen/viewmodels/onboarding_screen_viewmodel.dart';
import 'package:linum/screens/onboarding_screen/widgets/language_dropdown_menu.dart';
import 'package:linum/screens/onboarding_screen/widgets/onboarding_login_button.dart';
import 'package:linum/screens/onboarding_screen/widgets/onboarding_register_button.dart';
import 'package:linum/screens/onboarding_screen/widgets/onboarding_slide_indicator.dart';
import 'package:linum/screens/onboarding_screen/widgets/onboarding_slide_show.dart';
import 'package:linum/screens/onboarding_screen/widgets/views/login_view.dart';
import 'package:linum/screens/onboarding_screen/widgets/views/register_view.dart';
import 'package:provider/provider.dart';
import 'package:linum/screens/settings_screen/widgets/version_number.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingScreenViewModel viewModel =
      context.read<OnboardingScreenViewModel>();

    return ScreenSkeleton(
      head: '', // will not be displayed anyways
      contentOverride: true,
      screenKey: ScreenKey.onboarding,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          viewModel.setPageState(OnboardingPageState.none);
        },
        child: Stack(
          children: [
            const OnboardingSlideShow(),
            const Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: LanguageDropDownMenu(),
              ),
            ),
            Positioned(
              top: 20,
              right: 122,
              child: Saemulator -avd Pixel_3a_API_34_extension_level_7_x86_64feArea(
                child: VersionNumber(),

              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  const OnboardingSlideIndicator(),
                  SizedBox(
                    height: context.proportionateScreenHeight(32),
                  ),
                  const OnboardingRegisterButton(),
                  SizedBox(
                    height: context.proportionateScreenHeight(10),
                  ),
                  const OnboardingLoginButton(),
                ],
              ),
            ),
            // ignore: prefer_const_constructors
            LoginView(), // Won't reload on Language-Switch if const
            // ignore: prefer_const_constructors
            RegisterView(), // Won't reload on Language-Switch if const
          ],
        ),
      ),
    );
  }

}

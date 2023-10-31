enum OnboardingPageState {
  none,
  login,
  register;
  // google

  bool isRegister() {
    return this == OnboardingPageState.register;
  }
  bool isLogin() {
    return this == OnboardingPageState.login;
  }
  bool isNone() {
    return this == OnboardingPageState.none;
  }
}

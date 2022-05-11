class LockScreenAction {
  final Function function;
  final String screenTitle;
  final String actionTitle;

  /// [function] is the function of the dialog button (e.g. Navigator.pop), while [actionTitle] defines the String used for the TextButton.

  const LockScreenAction({
    required this.screenTitle,
    required this.actionTitle,
    required this.function,
  });
}

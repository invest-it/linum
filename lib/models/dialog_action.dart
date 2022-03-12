class DialogAction {
  final Function function;
  final String actionTitle;
  final DialogPurpose dialogPurpose;
  final bool popDialog;

  /// [function] is the function of the dialog button (e.g. Navigator.pop), while [actionTitle] defines the String used for the TextButton.
  /// Optional: With [dialogPurpose] you can instantly style the button. [DialogPurpose.PRIMARY] is used by default.
  ///
  /// [DialogPurpose.PRIMARY] - primary color, used for drawing user attention
  /// [DialogPurpose.SECONDARY] - secondary color, used for something we don't want the attention on
  /// [DialogPurpose.DANGER] - error color (red), used for when we want to signal something cannot be undone or causes a severe action
  const DialogAction({
    required this.actionTitle,
    required this.function,
    this.dialogPurpose = DialogPurpose.PRIMARY,
    this.popDialog = false,
  });
}

enum DialogPurpose {
  /// primary color, used for drawing user attention
  PRIMARY,

  /// secondary color, used for something we don't want the attention on
  SECONDARY,

  /// error color (red), used for when we want to signal something cannot be undone or causes a severe action
  DANGER,
}

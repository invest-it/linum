class DialogAction {
  final Function function;
  final String actionTitle;
  final DialogPurpose dialogPurpose;
  final bool popDialog;

  /// [function] is the function of the dialog button (e.g. Navigator.pop), while [actionTitle] defines the String used for the TextButton.
  /// Optional: With [dialogPurpose] you can instantly style the button. [DialogPurpose.primary] is used by default.
  ///
  /// [DialogPurpose.primary] - primary color, used for drawing user attention
  /// [DialogPurpose.secondary] - secondary color, used for something we don't want the attention on
  /// [DialogPurpose.danger] - error color (red), used for when we want to signal something cannot be undone or causes a severe action
  const DialogAction({
    required this.actionTitle,
    required this.function,
    this.dialogPurpose = DialogPurpose.primary,
    this.popDialog = false,
  });
}

enum DialogPurpose {
  /// primary color, used for drawing user attention
  primary,

  /// secondary color, used for something we don't want the attention on
  secondary,

  /// error color (red), used for when we want to signal something cannot be undone or causes a severe action
  danger,
}

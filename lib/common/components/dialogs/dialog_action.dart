//  DialogAction - Model for displaying a standard Action Button within a Popup Dialog including the type of action implied (Error, Warning, Info)
//
//  Author: NightmindOfficial
//  Co-Author: SoTBurst
//

class DialogAction {
  final void Function()? callback;
  final String actionTitle;
  final DialogPurpose dialogPurpose;

  /// [function] is the function of the dialog button (e.g. Navigator.pop), while [actionTitle] defines the String used for the TextButton.
  /// Optional: With [dialogPurpose] you can instantly style the button. [DialogPurpose.primary] is used by default.
  ///
  /// [DialogPurpose.primary] - primary color, used for drawing user attention
  /// [DialogPurpose.secondary] - secondary color, used for something we don't want the attention on
  /// [DialogPurpose.danger] - error color (red), used for when we want to signal something cannot be undone or causes a severe action
  const DialogAction({
    required this.actionTitle,
    this.callback,
    this.dialogPurpose = DialogPurpose.primary,
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

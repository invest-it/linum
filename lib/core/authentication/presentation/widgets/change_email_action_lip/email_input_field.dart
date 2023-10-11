import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function() onEditingComplete;
  const EmailInputField({
    super.key,
    required this.controller,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: ()=>onEditingComplete(),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: tr(
            translationKeys.actionLip.changeEmail.hintLabel,
          ),
          hintStyle: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EmailInputField extends StatelessWidget {
  final TextEditingController? controller;
  final Function() onEditingComplete;
  final String hintLabel;
  final String? Function(String?)? validator;
  const EmailInputField({
    super.key,
    this.controller,
    required this.onEditingComplete,
    required this.hintLabel,
    this.validator,
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
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintLabel,
          hintStyle: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}

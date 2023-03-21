import 'package:flutter/material.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/continue_button.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/delete_button.dart';
import 'package:linum/screens/enter_screen/widgets/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/widgets/quick_tag_menu.dart';

class EnterScreenForm extends StatelessWidget {
  const EnterScreenForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 10,
            ),
            child: const EnterScreenTextField(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: QuickTagMenu(),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                EnterScreenDeleteButton(),
                EnterScreenContinueButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

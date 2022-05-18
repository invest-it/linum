import 'package:flutter/material.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/screens/survey_screen.dart';

class SurveyButton extends StatefulWidget {
  const SurveyButton({Key? key}) : super(key: key);

  @override
  State<SurveyButton> createState() => _SurveyButtonState();
}

class _SurveyButtonState extends State<SurveyButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: const Key("SurveyButton"),
      onPressed: () => Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => const SurveyPage(),
        ),
      ),
      style: OutlinedButton.styleFrom(
        elevation: 8,
        shadowColor: Theme.of(context).colorScheme.onBackground,
        minimumSize: Size(
          double.infinity,
          proportionateScreenHeight(48),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        "Feedback geben", //TODO translate this
        style: Theme.of(context)
            .textTheme
            .button
            ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}

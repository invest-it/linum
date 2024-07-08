import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/balance/services/algorithm_service.dart';
import 'package:provider/provider.dart';

class MonthSlide extends StatelessWidget {
  final Widget child;
  const MonthSlide({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final algorithms = context.watch<AlgorithmService>();

    final String langCode = context.locale.languageCode;
    final DateFormat dateFormat = DateFormat('MMMM yyyy', langCode);


    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                algorithms.previousMonth(notify: true);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
              ),
            ),
            Expanded(
              child: child,
            ),
            IconButton(
              onPressed: () {
                algorithms.nextMonth(notify: true);
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          ],
        ),
        Text(dateFormat.format(algorithms.state.shownMonth)),
      ],
    );
  }
}

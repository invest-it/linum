import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/generated/translation_keys.g.dart';

class TransactionTileBackground extends StatelessWidget {
  const TransactionTileBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              children: [
                Text(
                  tr(translationKeys.listview.dismissible.labelDelete),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

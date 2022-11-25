import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/categories_repeat.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/models/repeat_configuration.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/silent_scroll.dart';
import 'package:provider/provider.dart';

class RepeatCategoryListView extends StatelessWidget {
  const RepeatCategoryListView({super.key});

  void _selectRepeatItem(
      BuildContext context,
      RepeatDuration configKey,
      RepeatConfiguration? config,
      ) {
    final enterScreenProvider =
      Provider.of<EnterScreenProvider>(context, listen: false);

    Provider.of<ActionLipStatusProvider>(context, listen: false)
        .setActionLipStatus(providerKey: ProviderKey.enter);

    enterScreenProvider
        .setRepeatDurationEnumSilently(configKey);
    enterScreenProvider.setRepeatDuration(config?.duration);
    if (config?.durationType != null) {
      enterScreenProvider.setRepeatDurationType(config!.durationType!);
    }

  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: SilentScroll(),
      child: ListView.builder(
        itemCount: repeatConfigurations.length,
        itemBuilder: (BuildContext context, int index) {
          final configKey = RepeatDuration.values[index];
          final config = repeatConfigurations[configKey];
          return ListTile(
            leading: Icon(
              config?.entryCategory.icon ?? Icons.error,
            ),
            title: Text(
              tr(config?.entryCategory.label ?? ""),
            ),
            onTap: () => _selectRepeatItem(
              context,
              configKey,
              config,
            ),
          );
        },
      ),
    );
  }
}

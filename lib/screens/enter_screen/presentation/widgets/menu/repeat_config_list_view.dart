import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/linum_close_button.dart';
import 'package:provider/provider.dart';

class RepeatConfigListView extends StatelessWidget {
  final repeatConfigs = repeatConfigurations.values.toList();
  RepeatConfigListView({super.key});

  @override
  Widget build(BuildContext context) {
    final formViewModel = context.read<EnterScreenFormViewModel>();

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: context.proportionateScreenHeightFraction(ScreenFraction.onetenth),
              ),
              itemCount: repeatConfigs.length,
              itemBuilder: (context, index) {
                final repeatConfig = repeatConfigs[index];
                return ListTile(
                  title: Text(
                    repeatConfig.label.tr(),
                  ),
                  leading: Icon(repeatConfig.icon),
                  onTap: () {
                    formViewModel.data = formViewModel.data.copyWithOptions(
                      repeatConfiguration: repeatConfig,
                    );
                    Navigator.pop(context);
                  },
                  selected: formViewModel.data.options.repeatConfiguration
                      ?.interval == repeatConfig.interval,
                );
              },
            ),
          ),
          const LinumCloseButton(),
        ],
      ),
    );
  }
}

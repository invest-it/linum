import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/base_translator.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/presentation/utils/get_default_values.dart';
import 'package:linum/screens/enter_screen/presentation/utils/initial_form_data_builder.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/abort_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/continue_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/delete_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/entry_type_switch.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/enter_screen_scaffold.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/form/enter_screen_text_field.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/form/quick_tag_menu.dart';
import 'package:provider/provider.dart';

class EnterScreenFormView extends StatelessWidget {
  const EnterScreenFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;


    return ChangeNotifierProxyProvider<EnterScreenViewModel, EnterScreenFormViewModel>(
      create: (context) => _createViewModel(context, locale.languageCode),
      update: (context, viewModel, formViewModel) {
        if (formViewModel == null) {
          return _createViewModel(context, locale.languageCode);
        }
        formViewModel.handleUpdate(
          viewModel.entryType,
        );
        return formViewModel;
      },
      child: EnterScreenScaffold(
        bodyHeight: 400 + useKeyBoardHeight(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 10,
                        ),

                        child: const EnterScreenTextField(),
                      ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 55,
                      top: 18,
                      bottom: 10,
                    ),
                    child: EnterScreenAbortButton(),
                  ),
                ],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: QuickTagMenu(),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: const Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EnterScreenDeleteButton(),
                    EnterScreenEntryTypeSwitch(),
                    EnterScreenContinueButton(),
                  ],
                ),
              ),
              Container(
                height: useKeyBoardHeight(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EnterScreenFormViewModel _createViewModel(BuildContext context, String languageCode) {

    final builder = InitialFormDataBuilder(
      currencies: standardCurrencies,
      repeatConfigurations: repeatConfigurations,
      translator: BaseTranslator(languageCode),
    );
    final screenViewModel = context.read<EnterScreenViewModel>();
    builder
      ..useTransaction(
        screenViewModel.initialTransaction,
        parentalSerialTransaction: screenViewModel.parentalSerialTransaction,
      )
      ..useSerialTransaction(
        screenViewModel.initialSerialTransaction,
      )
      ..entryType = screenViewModel.entryType;

    final initialData = builder.build();
    return EnterScreenFormViewModel(
      defaultValues: getDefaultValues(context),
      initialData: initialData,
      entryType: screenViewModel.entryType,
    );
  }
}

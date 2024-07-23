import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/base_translator.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/core/design/layout/utils/media_query_accessors.dart';
import 'package:linum/core/repeating/constants/standard_repeat_configs.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/domain/models/suggestion_filters.dart';
import 'package:linum/screens/enter_screen/presentation/utils/context_extensions.dart';
import 'package:linum/screens/enter_screen/presentation/utils/get_default_values.dart';
import 'package:linum/screens/enter_screen/presentation/utils/initial_form_data_builder.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_view_model.dart';
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
      child: const _EnterScreenFormView(),
    );
  }

  EnterScreenFormViewModel _createViewModel(BuildContext context, String languageCode) {
    final translator = BaseTranslator(languageCode);
    final builder = InitialFormDataBuilder(
      currencies: standardCurrencies,
      repeatConfigurations: repeatConfigurations,
      translator: translator,
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
      translator: translator,
    );
  }
}

class _EnterScreenFormView extends StatelessWidget {
  const _EnterScreenFormView();


  @override
  Widget build(BuildContext context) {
    final keyboardHeight = useKeyBoardHeight(context);
    context.read<EnterScreenFormViewModel>()
        .keyboardStateListener.inform(keyboardHeight);

    final fixedHeight = context.scaledHeight(400);
    final availableSpace = useScreenHeight(context) - fixedHeight - 30;
    final adjustedKeyboardHeight = min(keyboardHeight, availableSpace);

    return EnterScreenScaffold(
      bodyHeight: fixedHeight + adjustedKeyboardHeight,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),

                        child: EnterScreenTextField(
                          parsingFilters: ParsingFilters(
                            categoryFilter: (category) => category.entryType == context.getEntryType(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: QuickTagMenu(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            EnterScreenDeleteButton(),
                            EnterScreenEntryTypeSwitch(),
                            EnterScreenContinueButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: adjustedKeyboardHeight,
            ),
          ],
        ),
      ),
    );
  }
}

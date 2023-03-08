//  Enter Screen ListView Builder - Builds a Transaction List View
//
//  Author: thebluebaronx
//  Co-Author: SoTBurst
//

// ignore_for_file: avoid_dynamic_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/constants/categories_repeat.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_currencies.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
import 'package:linum/widgets/enter_screen/currency_list_view.dart';
import 'package:linum/widgets/enter_screen/enter_screen_list_tile.dart';
import 'package:linum/widgets/enter_screen/expense_category_list_view.dart';
import 'package:linum/widgets/enter_screen/income_category_list_view.dart';
import 'package:linum/widgets/enter_screen/repeat_category_list_view.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

// ignore_for_file: deprecated_member_use
//TODO DEPRECATED

class EnterScreenListView extends StatefulWidget {
  @override
  _EnterScreenListViewState createState() => _EnterScreenListViewState();
}

class _EnterScreenListViewState extends State<EnterScreenListView> {
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2000);
  final lastDate = DateTime(DateTime.now().year + 5, 12);

  TextEditingController? myController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (myController != null) {
      myController!.dispose();
    }
    super.dispose();
  }

  final currencies = standardCurrencies.values.toList();

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context, listen: false);
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);

    final repeatConfig =
        repeatConfigurations[enterScreenProvider.repeatDurationEnum];
    final currency = standardCurrencies[enterScreenProvider.currency];

    final String langCode = context.locale.languageCode;
    final DateFormat formatter = DateFormat('dd. MMMM yyyy', langCode);

    myController ??= TextEditingController(text: enterScreenProvider.name);
    return Expanded(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: proportionateScreenHeight(50),
            ),
            SizedBox(
              width: proportionateScreenWidth(281),
              child: TextField(
                maxLength: 32,
                controller: myController,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: _hintTextChooser(enterScreenProvider),
                  hintStyle: const TextStyle(),
                  counter: const SizedBox.shrink(),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headline5,
                onTap: () => actionLipStatusProvider.setActionLipStatus(
                  providerKey: ProviderKey.enter,
                  status: ActionLipStatus.hidden,
                ),
                onChanged: (_) {
                  enterScreenProvider.setName(myController!.text);
                },
              ),
            ),
            SizedBox(
              width: proportionateScreenWidth(300),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    EnterScreenListTile(
                      onTap: () {
                        _openActionLip(
                          title: 'enter_screen_attribute_category'.tr(),
                          listView:
                              _chooseCategoryListView(enterScreenProvider),
                        );
                      },
                      icon: _chooseCategoryIcon(enterScreenProvider),
                      label: 'enter_screen_attribute_category'.tr(),
                      currentSelection: _chooseCategoryText(
                        enterScreenProvider,
                        accountSettingsProvider,
                      ),
                    ),
                    EnterScreenListTile(
                      onTap: () {
                        _openDatePicker(enterScreenProvider);
                      },
                      icon: const Icon(Icons.event),
                      label: 'enter_screen_attribute_date'.tr(),
                      currentSelection:
                          formatter.format(enterScreenProvider.selectedDate),
                    ),
                    EnterScreenListTile(
                      onTap: () {
                        _openActionLip(
                          title: 'enter_screen_attribute_currency'.tr(),
                          listView: const CurrencyListView(),
                        );
                      },
                      icon: const Icon(Icons.currency_exchange_outlined),
                      label: 'enter_screen_attribute_currency'.tr(),
                      currentSelection: currency != null
                          ? "${currency.label.tr()} (${currency.symbol})"
                          : "currency.error.not-found",
                    ),
                    EnterScreenListTile(
                      onTap: () {
                        _openActionLip(
                          title: 'enter_screen_attribute_repeat'.tr(),
                          listView: const RepeatCategoryListView(),
                        );
                      },
                      icon: Icon(repeatConfig!.entryCategory.icon),
                      label: 'enter_screen_attribute_repeat'.tr(),
                      currentSelection: repeatConfig.entryCategory.label.tr(),
                    )
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //function executed when one of the categories (category, account, date etc.) is tapped
  void _openActionLip({
    required String title,
    required Widget listView,
  }) {
    final provider =
        Provider.of<ActionLipStatusProvider>(context, listen: false);

    FocusManager.instance.primaryFocus?.unfocus();
    provider.setActionLip(
      providerKey: ProviderKey.enter,
      actionLipStatus: ActionLipStatus.onviewport,
      actionLipTitle: title,
      actionLipBody: SingleChildScrollView(
        child: SizedBox(
          height: proportionateScreenHeight(419),
          child: listView,
        ),
      ),
    );
  }

  //which hint text at the upper text field is shown
  String _hintTextChooser(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return tr('enter_screen.expenses-textfield-title');
    } else if (enterScreenProvider.isIncome) {
      return tr('enter_screen.income-textfield-title');
    } else {
      return tr('enter_screen.transaction-textfield-title');
    }
  }

  Widget _chooseCategoryListView(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return const ExpenseCategoryListView();
    }
    return const IncomeCategoryListView();
  }

  //returns the selected value as a text
  String _chooseCategoryText(
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
  ) {
    if (enterScreenProvider.isExpenses) {
      if (enterScreenProvider.category == "") {
        return tr(
          standardExpenseCategories[StandardCategoryExpense.none]!.label,
        );
      }
      return tr(
        standardExpenseCategories[enterScreenProvider.category]?.label ??
            'chosen expense',
      );
    } else {
      if (enterScreenProvider.category == "") {
        return tr(
          standardIncomeCategories[StandardCategoryIncome.none]!.label,
        );
      }
      return tr(
        standardIncomeCategories[enterScreenProvider.category]?.label ??
            'chosen income',
      );
    }
  }

  Icon _chooseCategoryIcon(
    EnterScreenProvider enterScreenProvider,
  ) {
    if (enterScreenProvider.isExpenses) {
      return Icon(
        standardExpenseCategories[enterScreenProvider.category]!.icon,
      );
    } else if (enterScreenProvider.isIncome) {
      return Icon(standardIncomeCategories[enterScreenProvider.category]!.icon);
    }
    return const Icon(Icons.error);
  }

//functions that set the category, account item etc when tapped

  Future<void> _openDatePicker(EnterScreenProvider enterScreenProvider) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: enterScreenProvider.selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate == null) {
      return;
    }
    final TimeOfDay timeOfDay = TimeOfDay.now();

    // ignore: unnecessary_null_comparison
    if (timeOfDay != null) {
      enterScreenProvider.setSelectedDate(
        pickedDate.add(
          Duration(
            hours: timeOfDay.hour,
            minutes: timeOfDay.minute,
          ),
        ),
      );
    }
  }
}

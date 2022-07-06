//  Enter Screen ListView Builder - Builds a Transaction List View
//
//  Author: thebluebaronx
//  Co-Author: SoTBurst
//

// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:linum/constants/categories_repeat.dart';
import 'package:linum/constants/repeat_duration_type_enum.dart';
import 'package:linum/constants/settings_enums.dart';
import 'package:linum/constants/standard_expense_categories.dart';
import 'package:linum/constants/standard_income_categories.dart';
import 'package:linum/models/entry_category.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';

import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:provider/provider.dart';

class EnterScreenListViewBuilder extends StatefulWidget {
  @override
  _EnterScreenListViewBuilderState createState() =>
      _EnterScreenListViewBuilderState();
}

class _EnterScreenListViewBuilderState
    extends State<EnterScreenListViewBuilder> {
  // String selectedCategory = "";

  EntryCategory timeEntryCategory = const EntryCategory(
    label: 'enter_screen_attribute_date',
    icon: Icons.event,
  );
  EntryCategory repeatDurationEntryCategory = const EntryCategory(
    label: 'enter_screen_attribute_repeat',
    icon: Icons.loop,
  );

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

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);
    final ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);
    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);

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
                ),
                onChanged: (_) {
                  enterScreenProvider.setName(myController!.text);
                },
              ),
            ),
            SizedBox(
              width: proportionateScreenWidth(300),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: calculateItemCount(enterScreenProvider),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _onCategoryPressed(
                      index,
                      enterScreenProvider,
                      accountSettingsProvider,
                      actionLipStatusProvider,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                  offset: Offset(
                                    0.5,
                                    2.0,
                                  ), // shadow direction: bottom right
                                )
                              ],
                            ),
                            child: Icon(
                              <IconData>[
                                _selectIcon(enterScreenProvider).icon ??
                                    Icons.error,
                                timeEntryCategory.icon,
                                categoriesRepeat[enterScreenProvider
                                        .repeatDurationEnum]!["entryCategory"]
                                    .icon as IconData,
                              ][index],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              [
                                "enter_screen_attribute_category",
                                timeEntryCategory.label,
                                repeatDurationEntryCategory.label,
                              ][index],
                            )}: ",
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          //displays the selecte option behind the category/repetiton etc.
                          //e.g. Category : Food <-- Food is the select Text
                          _selectText(
                            index,
                            enterScreenProvider,
                            accountSettingsProvider,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateItemCount(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.editMode) {
      return 2;
    } else {
      return 3;
    }
  }

  //function executed when one of the categories (category, account, date etc.) is tapped
  void _onCategoryPressed(
      int index,
      EnterScreenProvider enterScreenProvider,
      AccountSettingsProvider accountSettingsProvider,
      ActionLipStatusProvider actionLipStatusProvider) {
    if (index == 1) {
      //opens the date picker
      _openDatePicker(enterScreenProvider);
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      actionLipStatusProvider.setActionLip(
        providerKey: ProviderKey.enter,
        actionLipStatus: ActionLipStatus.onviewport,
        actionLipTitle: _typeChooser(
          enterScreenProvider,
          accountSettingsProvider,
          index,
        ),
        actionLipBody: SingleChildScrollView(
          child: SizedBox(
            height: proportionateScreenHeightFraction(ScreenFraction.twofifths),
            child: _chooseListViewBuilder(
              enterScreenProvider,
              index,
              accountSettingsProvider,
              actionLipStatusProvider,
            ),
          ),
        ),
      );
    }
  }

  //which hint text at the upper text field is shown
  String _hintTextChooser(EnterScreenProvider enterScreenProvider) {
    if (enterScreenProvider.isExpenses) {
      return AppLocalizations.of(context)!
          .translate('enter_screen/expenses-textfield-title');
    } else if (enterScreenProvider.isIncome) {
      return AppLocalizations.of(context)!
          .translate('enter_screen/income-textfield-title');
    } else {
      return AppLocalizations.of(context)!
          .translate('enter_screen/transaction-textfield-title');
    }
  }

  //which icon will displayed depending on expense etc.
  // Icon _iconChooser(enterScreenProvider, categoriesExpenses, index,
  //     categoriesIncome, categoriesTransaction) {
  //   if (enterScreenProvider.isExpenses) {
  //     return Icon(categoriesExpenses.elementAt(index).icon);
  //   } else if (enterScreenProvider.isIncome) {
  //     return Icon(categoriesIncome.elementAt(index).icon);
  //   } else
  //     return Icon(categoriesTransaction.elementAt(index).icon);
  // }

  //which text will displayed depending on expense etc.
  String _typeChooser(
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    int index,
  ) {
    return "${AppLocalizations.of(context)!.translate(
      [
        "enter_screen_attribute_category",
        timeEntryCategory.label,
        repeatDurationEntryCategory.label,
      ][index],
    )} ";
  }

  //which lists view is built depending on expense etc.
  ListView _chooseListViewBuilder(
    EnterScreenProvider enterScreenProvider,
    int index,
    AccountSettingsProvider accountSettingsProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(
        index,
        enterScreenProvider,
        accountSettingsProvider,
        actionLipStatusProvider,
      );
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(
        index,
        enterScreenProvider,
        accountSettingsProvider,
        actionLipStatusProvider,
      );
    } else {
      return _listViewBuilderTransaction(
        index,
        enterScreenProvider,
        accountSettingsProvider,
        actionLipStatusProvider,
      );
    }
  }

  //which list view is built depending on the tapped category at EXPENSES
  ListView _listViewBuilderExpenses(
    int index,
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    if (index == 0) {
      if (enterScreenProvider.isExpenses) {
        return ListView.builder(
          itemCount: standardExpenseCategories.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(
                standardExpenseCategories[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate(
                  standardExpenseCategories[
                          StandardCategoryExpense.values[indexBuilder]]!
                      .label,
                ),
              ),
              //selects the item as the categories value
              onTap: () => _selectCategoryItemExpenses(
                StandardCategoryExpense.values[indexBuilder]
                    .toString()
                    .split(".")[1],
                enterScreenProvider,
                standardExpenseCategories[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
                actionLipStatusProvider,
              ),
            );
          },
        );
      } else {
        return ListView.builder(
          itemCount: standardExpenseCategories.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(
                standardIncomeCategories[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .icon,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate(
                  standardIncomeCategories[
                          StandardCategoryIncome.values[indexBuilder]]!
                      .label,
                ),
              ),
              //selects the item as the categories value
              onTap: () => _selectCategoryItemIncome(
                  StandardCategoryIncome.values[indexBuilder]
                      .toString()
                      .split(".")[1],
                  enterScreenProvider,
                  standardIncomeCategories[
                          StandardCategoryExpense.values[indexBuilder]]!
                      .icon,
                  actionLipStatusProvider),
            );
          },
        );
      }
      // } else if (index == 1) {
      // return ListView.builder(
      //   itemCount: widget.categoriesAccount.length,
      //   itemBuilder: (BuildContext context, int indexBuilder) {
      //     return ListTile(
      //       leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
      //       title: Text(widget.categoriesAccount[indexBuilder].categoryName),
      //       //selects the item as the account value
      //       onTap: () => _selectAccountItem(
      //         widget.categoriesAccount[indexBuilder].categoryName,
      //         widget.categoriesAccount[indexBuilder].categoryIcon,
      //       ),
      //     );
      //   },
      // );
    } else {
      return ListView.builder(
        itemCount: categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
              categoriesRepeat[RepeatDuration.values[indexBuilder]]
                          ?["entryCategory"]
                      .icon as IconData? ??
                  Icons.error,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate(
                categoriesRepeat[RepeatDuration.values[indexBuilder]]
                        ?["entryCategory"]
                    .label as String,
              ),
            ),
            //selects the item as the repeat value
            onTap: () => _selectRepeatItem(enterScreenProvider, indexBuilder,
                accountSettingsProvider, actionLipStatusProvider),
          );
        },
      );
    }
  }
  //which list view is built depending on the tapped category at INCOME

  ListView _listViewBuilderIncome(
    int index,
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    if (index == 0) {
      return ListView.builder(
        itemCount: standardIncomeCategories.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
              standardIncomeCategories[
                      StandardCategoryIncome.values[indexBuilder]]!
                  .icon,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate(
                standardIncomeCategories[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .label,
              ),
            ),
            onTap: () => _selectCategoryItemIncome(
                StandardCategoryIncome.values[indexBuilder]
                    .toString()
                    .split(".")[1],
                enterScreenProvider,
                standardIncomeCategories[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .icon,
                actionLipStatusProvider),
          );
        },
      );
      // } else if (index == 1) {
      // return ListView.builder(
      //   itemCount: widget.categoriesAccount.length,
      //   itemBuilder: (BuildContext context, int indexBuilder) {
      //     return ListTile(
      //       leading: Icon(widget.categoriesAccount[indexBuilder].categoryIcon),
      //       title: Text(widget.categoriesAccount[indexBuilder].categoryName),
      //       onTap: () => _selectAccountItem(
      //         widget.categoriesAccount[indexBuilder].categoryName,
      //         widget.categoriesAccount[indexBuilder].categoryIcon,
      //       ),
      //     );
      //   },
      // );
    } else {
      return ListView.builder(
        itemCount: categoriesRepeat.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
              categoriesRepeat[RepeatDuration.values[indexBuilder]]
                          ?["entryCategory"]
                      .icon as IconData? ??
                  Icons.error,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate(
                categoriesRepeat[RepeatDuration.values[indexBuilder]]
                        ?["entryCategory"]
                    .label as String,
              ),
            ),
            onTap: () => _selectRepeatItem(enterScreenProvider, indexBuilder,
                accountSettingsProvider, actionLipStatusProvider),
          );
        },
      );
    }
  }
  //which list view is built depending on the tapped category at TRANSACTION

  ListView _listViewBuilderTransaction(
    int index,
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    return ListView.builder(
      itemCount: categoriesRepeat.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
          leading: Icon(
            categoriesRepeat[RepeatDuration.values[indexBuilder]]
                        ?["entryCategory"]
                    .icon as IconData? ??
                Icons.error,
          ),
          title: Text(
            AppLocalizations.of(context)!.translate(
              categoriesRepeat[RepeatDuration.values[indexBuilder]]
                      ?["entryCategory"]
                  .label as String,
            ),
          ),
          onTap: () => _selectRepeatItem(enterScreenProvider, indexBuilder,
              accountSettingsProvider, actionLipStatusProvider),
        );
      },
    );
  }

  //returns the selected value as a text
  Text _selectText(
    int index,
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
  ) {
    if (index == 0) {
      if (enterScreenProvider.isExpenses) {
        if (enterScreenProvider.category == "") {
          return Text(
            AppLocalizations.of(context)!.translate(
              standardExpenseCategories[StandardCategoryExpense.none]!.label,
            ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.translate(
            standardExpenseCategories[enterScreenProvider.category]?.label ??
                'chosen expense',
          ),
        );
      } else {
        if (enterScreenProvider.category == "") {
          return Text(
            AppLocalizations.of(context)!.translate(
              standardIncomeCategories[StandardCategoryIncome.none]!.label,
            ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.translate(
            standardIncomeCategories[enterScreenProvider.category]?.label ??
                'chosen income',
          ),
        );
      }
    } else if (index == 1) {
      final String langCode = AppLocalizations.of(context)!.locale.languageCode;

      final DateFormat formatter = DateFormat('dd. MMMM yyyy', langCode);
      return Text(formatter.format(enterScreenProvider.selectedDate));
    } else if (index == 2) {
      return Text(
        AppLocalizations.of(context)!.translate(
          categoriesRepeat[enterScreenProvider.repeatDurationEnum]
                  ?["entryCategory"]
              .label as String,
        ),
      );
    } else {
      log("Something has gone wrong with the index in enter_screen_listviewbuilder.dart");
      return Text(AppLocalizations.of(context)!.translate("main/label-error"));
    }
  }

  Icon _selectIcon(
    EnterScreenProvider enterScreenProvider,
  ) {
    if (enterScreenProvider.isExpenses) {
      /* if (index.runtimeType != StandardCategoryExpense) {
        log("Error index had wrong type to choose icon");
        log(
          "assumed: ${index.runtimeType} to be StandardCategoryExpense",
        );
        return const Icon(Icons.error);
      } */
      return Icon(
        standardExpenseCategories[enterScreenProvider.category]!.icon,
      );
    } else if (enterScreenProvider.isIncome) {
      /* if (index.runtimeType != StandardCategoryIncome) {
        log("Error index had wrong type to choose icon");
        log(
          "assumed: ${index.runtimeType} to be StandardCategoryIncome",
        );

        return const Icon(Icons.error);
      } */
      return Icon(standardIncomeCategories[enterScreenProvider.category]!.icon);
    }
    return const Icon(Icons.error);
  }

//functions that set the category, account item etc when tapped
  void _selectCategoryItemExpenses(
    String name,
    EnterScreenProvider enterScreenProvider,
    IconData icon,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    actionLipStatusProvider.setActionLipStatus(
      providerKey: ProviderKey.enter,
    );
    enterScreenProvider.setCategory(name);
  }

  void _selectCategoryItemIncome(
    String name,
    enterScreenProvider,
    IconData icon,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    actionLipStatusProvider.setActionLipStatus(
      providerKey: ProviderKey.enter,
    );
    enterScreenProvider.setCategory(name);
  }

  // ignore: unused_element
  void _selectCategoryItemTransactions(
    String name,
    EnterScreenProvider enterScreenProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    actionLipStatusProvider.setActionLipStatus(
      providerKey: ProviderKey.enter,
    );
    enterScreenProvider.setCategory(name);
  }

  void _selectRepeatItem(
    EnterScreenProvider enterScreenProvider,
    int index,
    AccountSettingsProvider accountSettingsProvider,
    ActionLipStatusProvider actionLipStatusProvider,
  ) {
    actionLipStatusProvider.setActionLipStatus(
      providerKey: ProviderKey.enter,
    );
    enterScreenProvider
        .setRepeatDurationEnumSilently(RepeatDuration.values[index]);
    enterScreenProvider.setRepeatDuration(
      categoriesRepeat[RepeatDuration.values[index]]?["duration"] as int?,
    );
    enterScreenProvider.setRepeatDurationType(
      categoriesRepeat[RepeatDuration.values[index]]?["durationType"]
          as RepeatDurationType,
    );
  }

  Future<void> _openDatePicker(EnterScreenProvider enterScreenProvider) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: enterScreenProvider.selectedDate,
      //which date will display when user open the picker
      firstDate: firstDate,
      //what will be the previous supported year in picker
      lastDate: lastDate,
    ); //what will be the up to supported date in picker

    //then usually do the future job
    if (pickedDate == null) {
      //if user tap cancel then this function will stop
      return;
    }
    final TimeOfDay timeOfDay = TimeOfDay.now();
    // Deactivated for now
    /* = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                  primary: Theme.of(context).colorScheme.primary),
            ),
            child: child!);
      },
    );*/
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

  // String validateMyInput(String value) {
  //   RegExp regex = new RegExp(r'^(?=\D*(?:\d\D*){1,12}$)\d+(?:\.\d{1,4})?$');
  //   if (!regex.hasMatch(value))
  //     return 'Enter Valid Number';
  //   else
  //     return 'Nothing';
  // }
}
// TODO: Refactor!!

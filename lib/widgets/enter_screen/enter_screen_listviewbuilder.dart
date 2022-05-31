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
import 'package:linum/providers/enter_screen_provider.dart';
import 'package:linum/utilities/backend/local_app_localizations.dart';
import 'package:linum/utilities/frontend/size_guide.dart';
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

  TextEditingController? nameController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (nameController != null) {
      nameController!.dispose();
    }
    super.dispose();
    if (descriptionController != null) {
      descriptionController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    final EnterScreenProvider enterScreenProvider =
        Provider.of<EnterScreenProvider>(context);
    nameController ??= TextEditingController(text: enterScreenProvider.name);
    nameController ??=
        TextEditingController(text: enterScreenProvider.description);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: proportionateScreenHeight(50),
            ),
            //the text field where the user describes e.g. what he bought
            SizedBox(
              width: proportionateScreenWidth(281),
              child: TextField(
                maxLength: 32,
                controller: nameController,
                showCursor: true,
                decoration: InputDecoration(
                  hintText: _hintTextChooser(enterScreenProvider),
                  hintStyle: const TextStyle(),
                  counter: const SizedBox.shrink(),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.headline5,
                onChanged: (_) {
                  enterScreenProvider.setName(nameController!.text);
                },
              ),
            ),
            SizedBox(
              width: proportionateScreenWidth(300),
              //the list view that contains the different categories
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                //primary: true,
                padding: const EdgeInsets.all(8),
                //as repeat is the last item and we dont want to implement it
                //in the MVP the itemCount has to be cut by one
                itemCount: calculateItemCount(enterScreenProvider),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => _onCategoryPressed(
                      index,
                      // widget.categoriesTransaction,
                      enterScreenProvider,
                      accountSettingsProvider,
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
            SizedBox(
              width: proportionateScreenWidth(281),
              child: TextField(
                //scrollPadding: EdgeInsets.only(bottom: bottomInsets + 40),
                textInputAction: TextInputAction.newline,
                controller: descriptionController,
                showCursor: true,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
                style: Theme.of(context).textTheme.bodyText1,
                onChanged: (_) {
                  enterScreenProvider
                      .setDescription(descriptionController!.text);
                },
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
  ) {
    if (index == 1) {
      //opens the date picker
      _openDatePicker(enterScreenProvider);
    } else {
      //opens a modal bottom sheet
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: proportionateScreenHeight(400),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Icon(
                        <IconData>[
                          _selectIcon(enterScreenProvider).icon ?? Icons.error,
                          timeEntryCategory.icon,
                          repeatDurationEntryCategory.icon,
                        ][index],
                      ),
                    ),
                    Column(
                      children: [
                        //text depending on the category
                        _typeChooser(
                          enterScreenProvider,
                          accountSettingsProvider,
                          index,
                        ),
                      ],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: proportionateScreenHeight(300),
                    //which list view is displayed depending on which category is tapped
                    child: _chooseListViewBuilder(
                      enterScreenProvider,
                      index,
                      accountSettingsProvider,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
  Text _typeChooser(
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
    int index,
  ) {
    return Text(
      "${AppLocalizations.of(context)!.translate(
        [
          "enter_screen_attribute_category",
          timeEntryCategory.label,
          repeatDurationEntryCategory.label,
        ][index],
      )}: ",
    );
  }

  //which lists view is built depending on expense etc.
  ListView _chooseListViewBuilder(
    EnterScreenProvider enterScreenProvider,
    int index,
    AccountSettingsProvider accountSettingsProvider,
  ) {
    if (enterScreenProvider.isExpenses) {
      return _listViewBuilderExpenses(
        index,
        enterScreenProvider,
        accountSettingsProvider,
      );
    } else if (enterScreenProvider.isIncome) {
      return _listViewBuilderIncome(
        index,
        enterScreenProvider,
        accountSettingsProvider,
      );
    } else {
      return _listViewBuilderTransaction(
        index,
        enterScreenProvider,
        accountSettingsProvider,
      );
    }
  }

  //which list view is built depending on the tapped category at EXPENSES
  ListView _listViewBuilderExpenses(
    int index,
    EnterScreenProvider enterScreenProvider,
    AccountSettingsProvider accountSettingsProvider,
  ) {
    if (index == 0) {
      if (enterScreenProvider.isExpenses) {
        return ListView.builder(
          itemCount: standardCategoryExpenses.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(
                standardCategoryExpenses[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate(
                  standardCategoryExpenses[
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
                standardCategoryExpenses[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
            );
          },
        );
      } else {
        return ListView.builder(
          itemCount: standardCategoryExpenses.length,
          itemBuilder: (BuildContext context, int indexBuilder) {
            return ListTile(
              leading: Icon(
                standardCategoryIncomes[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .icon,
              ),
              title: Text(
                AppLocalizations.of(context)!.translate(
                  standardCategoryIncomes[
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
                standardCategoryIncomes[
                        StandardCategoryExpense.values[indexBuilder]]!
                    .icon,
              ),
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
            onTap: () => _selectRepeatItem(
              enterScreenProvider,
              indexBuilder,
              accountSettingsProvider,
            ),
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
  ) {
    if (index == 0) {
      return ListView.builder(
        itemCount: standardCategoryIncomes.length,
        itemBuilder: (BuildContext context, int indexBuilder) {
          return ListTile(
            leading: Icon(
              standardCategoryIncomes[
                      StandardCategoryIncome.values[indexBuilder]]!
                  .icon,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate(
                standardCategoryIncomes[
                        StandardCategoryIncome.values[indexBuilder]]!
                    .label,
              ),
            ),
            onTap: () => _selectCategoryItemIncome(
              StandardCategoryIncome.values[indexBuilder]
                  .toString()
                  .split(".")[1],
              enterScreenProvider,
              standardCategoryIncomes[
                      StandardCategoryIncome.values[indexBuilder]]!
                  .icon,
            ),
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
            onTap: () => _selectRepeatItem(
              enterScreenProvider,
              indexBuilder,
              accountSettingsProvider,
            ),
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
          onTap: () => _selectRepeatItem(
            enterScreenProvider,
            indexBuilder,
            accountSettingsProvider,
          ),
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
              standardCategoryExpenses[StandardCategoryExpense.none]!.label,
            ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.translate(
            standardCategoryExpenses[enterScreenProvider.category]?.label ??
                'chosen expense',
          ),
        );
      } else {
        if (enterScreenProvider.category == "") {
          return Text(
            AppLocalizations.of(context)!.translate(
              standardCategoryIncomes[StandardCategoryIncome.none]!.label,
            ),
          );
        }
        return Text(
          AppLocalizations.of(context)!.translate(
            standardCategoryIncomes[enterScreenProvider.category]?.label ??
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
        standardCategoryExpenses[enterScreenProvider.category]!.icon,
      );
    } else if (enterScreenProvider.isIncome) {
      /* if (index.runtimeType != StandardCategoryIncome) {
        log("Error index had wrong type to choose icon");
        log(
          "assumed: ${index.runtimeType} to be StandardCategoryIncome",
        );

        return const Icon(Icons.error);
      } */
      return Icon(standardCategoryIncomes[enterScreenProvider.category]!.icon);
    }
    return const Icon(Icons.error);
  }

//functions that set the category, account item etc when tapped
  void _selectCategoryItemExpenses(
    String name,
    enterScreenProvider,
    IconData icon,
  ) {
    Navigator.pop(context);
    enterScreenProvider.setCategory(name);
  }

  void _selectCategoryItemIncome(
    String name,
    enterScreenProvider,
    IconData icon,
  ) {
    Navigator.pop(context);
    enterScreenProvider.setCategory(name);
  }

  // ignore: unused_element
  void _selectCategoryItemTransactions(
    String name,
    EnterScreenProvider enterScreenProvider,
  ) {
    Navigator.pop(context);

    enterScreenProvider.setCategory(name);
  }

  void _selectRepeatItem(
    EnterScreenProvider enterScreenProvider,
    int index,
    AccountSettingsProvider accountSettingsProvider,
  ) {
    Navigator.pop(context);
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

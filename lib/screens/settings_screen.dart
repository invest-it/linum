import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/country_flag_generator.dart';
import 'package:linum/frontend_functions/list_divider.dart';
import 'package:linum/frontend_functions/list_header.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/frontend_functions/silent-scroll.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/providers/account_settings_provider.dart';
import 'package:linum/providers/action_lip_status_provider.dart';
import 'package:linum/providers/pin_code_provider.dart';
import 'package:linum/widgets/auth/forgot_password.dart';
import 'package:linum/widgets/auth/logout_form.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
import 'package:linum/widgets/settings_screen/toggle_button_element.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page Index: 3
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //TODO PACKAGE-INFO-PLUS
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  String dropdownValue = 'Euro (EUR, €)';

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    AccountSettingsProvider accountSettingsProvider =
        Provider.of<AccountSettingsProvider>(context);

    ActionLipStatusProvider actionLipStatusProvider =
        Provider.of<ActionLipStatusProvider>(context);

    PinCodeProvider pinCodeProvider = Provider.of<PinCodeProvider>(context);

    return ScreenSkeleton(
      head: 'Account',
      providerKey: ProviderKey.SETTINGS,
      initialActionLipStatus: ActionLipStatus.HIDDEN,
      initialActionLipBody: Container(),
      body: ScrollConfiguration(
        behavior: SilentScroll(),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 24.0,
          ),
          children: [
            /// STANDARD CURRENCY
            /// FUTURE implement this properly, not the fucky-wucky this was before we decided to put it down
            // ListHeader(
            // 'settings_screen/standard-currency/label-title',
            // tooltipMessage: 'settings_screen/standard-currency/label-tooltip',
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     DropdownButtonFormField<String>(
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //       ),
            //       value: dropdownValue,
            //       icon: const Icon(Icons.arrow_drop_down),
            //       elevation: 16,
            //       style: const TextStyle(color: Colors.black),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           dropdownValue = newValue!;
            //         });
            //       },
            //       items: <String>[
            //         'Euro (EUR, €)',
            //         'Dollar (USD, \$)',
            //         'Pound Sterling (GBP, £)',
            //         'Yen (JPY, ¥)',
            //         'Krone (DKK, Kr.)',
            //       ].map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
            // ListDivider(T: 0),

            /// STANDARD CATEGORY
            ListHeader(
              'settings_screen/standard-category/label-title',
              tooltipMessage: 'settings_screen/standard-category/label-tooltip',
            ),

            /// TODO this is not lean programming and needs a rework.
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    //Request from SoTBurst - this fix is related to issue #46
                    actionLipStatusProvider.setActionLipStatus(
                        providerKey: ProviderKey.SETTINGS);

                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: proportionateScreenHeightFraction(
                              ScreenFraction.HALF),
                          color: Theme.of(context).colorScheme.onSecondary,
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-income-selector/label-title'),
                              ),
                            ),
                            Container(
                              height: proportionateScreenHeightFraction(
                                  ScreenFraction.TWOFIFTHS),
                              child: _incomeListViewBuilder(
                                accountSettingsProvider,
                              ),
                            ),
                          ]),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    // onTap: ontap(),
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                              'settings_screen/standard-income-selector/label-title') +
                          AppLocalizations.of(context)!.translate(
                              accountSettingsProvider
                                      .standardCategoryIncomes[EnumToString
                                          .fromString<StandardCategoryIncome>(
                                    StandardCategoryIncome.values,
                                    (accountSettingsProvider.settings[
                                            "StandardCategoryIncome"] ??
                                        "None"),
                                  )]
                                      ?.label ??
                                  "ChosenStandardIncome"), // yeah im sorry that is really complicated code. :( It translates the value from firebase
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    trailing: Icon(
                      Icons.north_east,
                      color: createMaterialColor(Color(0xFF97BC4E)),
                    ),
                    leading: Icon(
                      accountSettingsProvider
                              .standardCategoryIncomes[EnumToString.fromString<
                                  StandardCategoryIncome>(
                            StandardCategoryIncome.values,
                            (accountSettingsProvider
                                    .settings["StandardCategoryIncome"] ??
                                "None"),
                          )]
                              ?.icon ??
                          Icons.error,
                    ),
                  ),
                ),
                //Ende Einnahmen ListTile
                GestureDetector(
                  onTap: () {
                    //Request from SoTBurst - this fix is related to issue #46
                    actionLipStatusProvider.setActionLipStatus(
                        providerKey: ProviderKey.SETTINGS);

                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          color: createMaterialColor(Color(0xFFFAFAFA)),
                          child: Column(children: [
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)!.translate(
                                    'settings_screen/standard-expense-selector/label-title'),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: _expensesListViewBuilder(
                                accountSettingsProvider,
                              ),
                            ),
                          ]),
                        );
                      },
                    );
                  },
                  child: ListTile(
                    // onTap: ontap(),
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                              'settings_screen/standard-expense-selector/label-title') +
                          AppLocalizations.of(context)!.translate(
                              accountSettingsProvider
                                      .standardCategoryExpenses[EnumToString
                                          .fromString<StandardCategoryExpense>(
                                    StandardCategoryExpense.values,
                                    (accountSettingsProvider.settings[
                                            "StandardCategoryExpense"] ??
                                        "None"),
                                  )]
                                      ?.label ??
                                  "ChosenStandardExpense"), // yeah im sorry that is really complicated code. :( It translates the value from firebase
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    trailing: Icon(
                      Icons.south_east,
                      color: Colors.red,
                    ),
                    leading: Icon(
                      accountSettingsProvider
                              .standardCategoryExpenses[EnumToString.fromString<
                                  StandardCategoryExpense>(
                            StandardCategoryExpense.values,
                            (accountSettingsProvider
                                    .settings["StandardCategoryExpense"] ??
                                "None"),
                          )]
                              ?.icon ??
                          Icons.error,
                    ),
                  ),
                ),
              ],
            ),
            ListDivider(),

            ListHeader(
              'settings_screen/pin-lock/label-title',
              tooltipMessage: 'settings_screen/pin-lock/label-tooltip',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!
                        .translate("settings_screen/pin-lock/switch-label"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  value: pinCodeProvider.pinActive,
                  activeColor: Theme.of(context).colorScheme.primaryContainer,
                  onChanged: pinCodeProvider.pinActiveStillLoading
                      ? null
                      : (_) {
                          pinCodeProvider.togglePINLock();
                        },
                ),
                if (pinCodeProvider.pinActive)
                  ListTile(
                    dense: true,
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                          "settings_screen/pin-lock/label-change-pin"),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      pinCodeProvider.triggerPINChange();
                    },
                  ),
              ],
            ),
            ListDivider(),

            /// SPECIAL SETTINGS
            /// This setting will be hidden until implememted.
            // ListHeader('settings_screen/special-settings/label-title'),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     SwitchListTile(
            //       /// TODO implement schwabenmodus functionality
            //       title: Text(
            //         AppLocalizations.of(context)!.translate(
            //             'settings_screen/special-settings/label-schwabenmodus'),
            //         style: Theme.of(context).textTheme.bodyText1,
            //       ),
            //       value: _schwabenmodus,
            //       activeColor: Colors.green,
            //       onChanged: (bool value) {
            //         setState(() {
            //           _schwabenmodus = value;
            //         });
            //       },
            //     ),
            //   ],
            // ),
            // ListDivider(),

            /// STANDARD ACCOUNT (to be implemented)
            // ListHeader(
            //   'settings_screen/standard-account/label-title',
            //   tooltipMessage: 'settings_screen/standard-account/label-tooltip',
            // ),
            // // Einnahmen Selector (Accounts)
            // ListDivider(),

            /// LANGUAGE SWITCH
            ListHeader(
              'settings_screen/language-settings/label-title',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate(
                        'settings_screen/language-settings/label-systemlang'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  value: accountSettingsProvider.settings['systemLanguage'] ??
                      true,
                  activeColor: Theme.of(context).colorScheme.primary,
                  onChanged: (bool value) {
                    accountSettingsProvider
                        .updateSettings({'systemLanguage': value});
                  },
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    ToggleButtons(
                      children: [
                        ToggleButtonElement(countryFlag('de')),
                        ToggleButtonElement(countryFlag('gb')),
                        ToggleButtonElement(countryFlag('nl')),
                        ToggleButtonElement(countryFlag('es')),
                        ToggleButtonElement(countryFlag('fr')),
                      ],
                      isSelected: [
                        accountSettingsProvider.settings['languageCode'] ==
                            'de-DE',
                        accountSettingsProvider.settings['languageCode'] ==
                            'en-US',
                        accountSettingsProvider.settings['languageCode'] ==
                            'nl-NL',
                        accountSettingsProvider.settings['languageCode'] ==
                            'es-ES',
                        accountSettingsProvider.settings['languageCode'] ==
                            'fr-FR'
                      ],
                      onPressed:
                          accountSettingsProvider.settings['systemLanguage'] ==
                                  false
                              ? (int index) {
                                  String langSelector;
                                  switch (index) {
                                    case 0:
                                      langSelector = 'de-DE';
                                      break;
                                    case 1:
                                      langSelector = 'en-US';
                                      break;
                                    case 2:
                                      langSelector = 'nl-NL';
                                      break;
                                    case 3:
                                      langSelector = 'es-ES';
                                      break;
                                    case 4:
                                      langSelector = 'fr-FR';
                                      break;
                                    default:
                                      langSelector = 'en-US';
                                  }
                                  accountSettingsProvider.updateSettings(
                                      {'languageCode': langSelector});
                                }
                              : null,
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ],
                ),
              ],
            ),
            ListDivider(),

            /// YOUR ACCOUNT
            ListHeader('settings_screen/system-settings/label-title'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Authentication Actions (including logOut will be handled via widgets/auth from now on.)
                LogoutForm(),
                ForgotPasswordButton(ProviderKey.SETTINGS),
              ],
            ),
            //TODO Add Version Display here

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _packageInfo.appName +
                    ' Version ' +
                    _packageInfo.version +
                    ' (' +
                    _packageInfo.buildNumber +
                    ')',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    letterSpacing: 0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  //ListView.builder für Standard Kategorien

  ListView _incomeListViewBuilder(
      AccountSettingsProvider accountSettingsProvider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardCategoryIncome.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
            //leading: Icon(widget.categories[index].icon),
            title: Text(AppLocalizations.of(context)!.translate(
                accountSettingsProvider
                        .standardCategoryIncomes[
                            StandardCategoryIncome.values[indexBuilder]]
                        ?.label ??
                    "Category")),
            selected: "StandardCategoryIncome." +
                    (accountSettingsProvider
                            .settings["StandardCategoryIncome"] ??
                        "None") ==
                StandardCategoryIncome.values[indexBuilder].toString(),
            onTap: () {
              List<String> stringArr = StandardCategoryIncome
                  .values[indexBuilder]
                  .toString()
                  .split(".");
              accountSettingsProvider.updateSettings({
                stringArr[0]: stringArr[1],
              });
              Navigator.pop(context);
            }
            // trailing: ,
            );
      },
    );
  }

  ListView _expensesListViewBuilder(
      AccountSettingsProvider accountSettingsProvider) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: StandardCategoryExpense.values.length,
      itemBuilder: (BuildContext context, int indexBuilder) {
        return ListTile(
            //leading: Icon(widget.categories[index].icon),
            title: Text(AppLocalizations.of(context)!.translate(
                accountSettingsProvider
                        .standardCategoryExpenses[
                            StandardCategoryExpense.values[indexBuilder]]
                        ?.label ??
                    "Category")),
            selected: "StandardCategoryExpense." +
                    (accountSettingsProvider
                            .settings["StandardCategoryExpense"] ??
                        "None") ==
                StandardCategoryExpense.values[indexBuilder].toString(),
            onTap: () {
              List<String> stringArr = StandardCategoryExpense
                  .values[indexBuilder]
                  .toString()
                  .split(".");
              accountSettingsProvider.updateSettings({
                stringArr[0]: stringArr[1],
              });
              Navigator.pop(context);
            });
      },
    );
  }
}

// ignore: unused_element
ListView _currencyChange(_currency) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: _currency.length,
    itemBuilder: (BuildContext context, int indexBuilder) {
      return ListTile(
        //leading: Icon(widget.categories[index].icon),
        title: Text(_currency[indexBuilder]),
        // onTap: () => _selectCategoryItem(
        //     widget.categoriesCategoryIncome[indexBuilder],
        //     enterScreenProvider),
      );
    },
  );
}

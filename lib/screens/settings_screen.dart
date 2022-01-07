import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/widgets/screen_skeleton/screen_skeleton.dart';
//import 'package:linum/providers/balance_data_provider.dart';
//import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _toggled = false;

  @override
  // final Function ontap = CurrencyList();

  Widget build(BuildContext context) {
    // BalanceDataProvider balanceDataProvider =
    //     Provider.of<BalanceDataProvider>(context);
    return ScreenSkeleton(
        head: 'Account',
        isInverted: false,
        body: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Währung'),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Währung auswählen...'),
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                //line in between
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 16.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.001,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                //going on...
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Standard Kategorien'),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Einnahmen'),
                        trailing: Icon(
                          Icons.north_east,
                          color: createMaterialColor(Color(0xFF97BC4E)),
                        ),
                      ),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Ausgaben'),
                        trailing: Icon(
                          Icons.south_east,
                          color: Colors.red,
                        ),
                      ),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Transaktionen'),
                        trailing: Icon(
                          Icons.sync_alt,
                          color: createMaterialColor(Color(0xFF505050)),
                        ),
                      ),
                      //Icons disputable
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    top: 0,
                    bottom: 16.0,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.001,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 40.0,
                    right: 40.0,
                    bottom: 0,
                  ),
                  //ListTile for selecting currencies
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Besondere Einstellungen'),
                        SwitchListTile(
                          // onTap: ontap(),
                          title: Text('Schwabenmodus'),
                          value: _toggled,
                          activeColor: Colors.green,
                          onChanged: (bool value) {
                            setState((() {
                              _toggled = value;
                            }));
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ],
        ));
  }
}

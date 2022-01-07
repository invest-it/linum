import 'package:flutter/material.dart';
// import 'package:linum/providers/balance_data_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:linum/frontend_functions/materialcolor_creator.dart';

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
    //BalanceDataProvider balanceDataProvider =
    // Provider.of<BalanceDataProvider>(context);
    return Scaffold(
        body: Stack(
      children: [
        //Sceleton
        Column(
          children: <Widget>[
            //column including upperLip and body of settings page
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //the top, green lip
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.zero,
                    bottom: Radius.circular(40),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    // TODO change this into a sustainable and responsive design

                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            //body of the settings page
            Column(
              children: [
                //text: 'settings'
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
                      Text('Settings'),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('select currency'),
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
                      Text('Standard Categories'),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Income'),
                        trailing: Icon(
                          Icons.north_east,
                          color: Colors.black,
                        ),
                      ),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Expenses'),
                        trailing: Icon(
                          Icons.south_east,
                          color: Colors.black,
                        ),
                      ),
                      ListTile(
                        // onTap: ontap(),
                        title: Text('Transactions'),
                        trailing: Icon(
                          Icons.sync_alt,
                          color: Colors.black,
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
                        Text('Special Settings'),
                        SwitchListTile(
                          // onTap: ontap(),
                          title: Text('Schwabenmodus'),
                          value: _toggled,
                          onChanged: (_toggled) {
                            setState(() {
                              _toggled = true;
                            });
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ],
        ),
        //TODO: Account Logo
      ],
    ));
  }
}

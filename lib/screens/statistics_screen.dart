import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedItem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _onButtonPressed(),
              child: Text("Show"),
            ),
            Text(_selectedItem)
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 70,
          child: Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.ac_unit_outlined),
                  title: Text("cooling"),
                  onTap: () => _selectItem('Cooling'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectItem(String name) {
    Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
  }
}

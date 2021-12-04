import 'package:flutter/material.dart';

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({Key? key, required this.monthlyBudget})
      : super(key: key);

  final double monthlyBudget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 110,
      left: 10,
      right: 10,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.20,
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Aktueller Kontostand',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('Datum'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        monthlyBudget.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 1,
                      ),
                      Text(
                        '€',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

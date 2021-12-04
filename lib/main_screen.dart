import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
    required this.title,
    required this.monthlyBudget,
  }) : super(key: key);

  final String title;
  final double monthlyBudget;

  @override
  Widget build(BuildContext context) {
    CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');
    return Scaffold(
      backgroundColor: Colors.green[400],
      body: Center(
        child: StreamBuilder(
          stream: balance.snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      color: Colors.white,
                    ),
                  ],
                ),
                Positioned(
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
                ),
              ],
            );
            /*ListView(
                children: snapshot.data == null
                    ? [Text("Error")]
                    : snapshot.data!.docs.map((singleBalance) {
                        return ListTile(
                          title:
                              Text(singleBalance["singleBalance"].toString()),
                          onLongPress: () {
                            singleBalance.reference.delete();
                          },
                        );
                      }).toList());*/
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          balance.add({"singleBalance": "Second Test Text"});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    CollectionReference balance =
        FirebaseFirestore.instance.collection('balance');
    return Scaffold(
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
                      color: Colors.grey,
                    ),
                  ],
                ),
                Positioned(
                  top: 110,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 100,
                        color: Colors.grey,
                        child: Text("Your Button"),
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

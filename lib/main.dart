import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/screens/main_screen.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

void main() {
  log("test");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    log("starting build...");

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Something went wrong")));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthenticationService>(
                create: (_) {
                  log("starting create");
                  AuthenticationService auth =
                      AuthenticationService(FirebaseAuth.instance);
                  // auth
                  //     .signUp("Soencke.Evers@investit-academy.de", "initialPassword1")
                  //     .then((value) => log(value));
                  return auth;
                },
                lazy: false,
              ),
            ],
            child: MainScreen(
              title: widget.title,
              monthlyBudget: 420.69,
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(body: Center(child: Text("Loading")));
      },
    );
  }
}

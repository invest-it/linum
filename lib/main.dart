import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linum/frontend_functions/materialcolor_creator.dart';
import 'package:linum/providers/algorithm_provider.dart';
import 'package:linum/providers/balance_data_provider.dart';
import 'package:linum/screens/layout_screen.dart';
import 'package:linum/providers/authentication_service.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          //This is the colorScheme where we store the colors
          //the names should be self explaining
          //all those that are not custom are just fillers as ColorScheme lists
          //them all as required

          //use like this: Theme.of(context).colorScheme.NAME_OF_COLOR_STYLE
          colorScheme: ColorScheme(
              primary: createMaterialColor(Color(0xFF82B915)),
              primaryVariant: Colors.green,
              secondary: createMaterialColor(Color(0xFF505050)),
              secondaryVariant: Colors.green,
              surface: Colors.red,
              background: createMaterialColor(Color(0xFFFAFAFA)),
              error: createMaterialColor(Color(0xFFEB5757)),
              onPrimary: Colors.amber,
              onSecondary: createMaterialColor(Color(0xFFFAFAFA)),
              onSurface: Colors.lightBlue,
              onBackground: Colors.tealAccent,
              onError: Colors.black12,
              brightness: Brightness.light)),
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
                  AuthenticationService auth =
                      AuthenticationService(FirebaseAuth.instance);
                  auth
                      .signIn("Soencke.Evers@investit-academy.de",
                          "tempPassword123")
                      .then((value) => log("login status: " + value));
                  return auth;
                },
                lazy: false,
              ),
              ChangeNotifierProvider<AlgorithmProvider>(
                create: (_) => AlgorithmProvider(),
                lazy: false,
              ),
              ChangeNotifierProxyProvider2<AuthenticationService,
                  AlgorithmProvider, BalanceDataProvider>(
                create: (ctx) {
                  return BalanceDataProvider(ctx);
                },
                update: (ctx, auth, algo, _) {
                  return BalanceDataProvider(ctx);
                },
                lazy: false,
              ),
            ],
            child: LayoutScreen(
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

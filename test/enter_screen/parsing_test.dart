import 'package:flutter_test/flutter_test.dart';
import 'package:linum/screens/enter_screen/models/enter_screen_input.dart';
import 'package:tuple/tuple.dart';

void main() {
  group("enter_screen_parsing_test", () {
    test("parse text input correctly", () {
      // TODO: Init methods
      final testInputs = <Tuple2<String, EnterScreenInput>>[
        Tuple2(
          "30.0 EUR Testausgabe #Kategorie:Essen & Trinken",
          EnterScreenInput(
            "30.0 EUR Testausgabe",
            amount: 30.0,
            currency: "EUR",
            name: "Testausgabe",
          )..parsedInputs.addAll([

          ]),
        )
      ];


    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linum/backend_functions/local_app_localizations.dart';
import 'package:linum/frontend_functions/size_guide.dart';
import 'package:linum/widgets/budget_screen/time_widget.dart';

void main() {
  group("TimeWidget", () {
    testWidgets("should display given text in capslock",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            SizeGuide().init(context);
            return TimeWidget(
              displayValue: "Test text",
              isTranslated: true,
            );
          }),
        ),
      );

      final textFinder = find.text("TEST TEXT");
      expect(textFinder, findsOneWidget);
    });

    testWidgets("should display given text translated",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: [
            Locale('en', 'US'),
          ],

          localizationsDelegates: [
            // Local Translation of our coding team / Invest it! Community
            AppLocalizations.delegate,
          ],

          // Returns a locale which will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode ||
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          home: ListView(children: <Widget>[
            Builder(builder: (context) {
              SizeGuide().init(context);
              //AppLocalizations.of(context)!.load(locale: Locale("en", "US"));
              return Container();
            }),
            TimeWidget(
              displayValue: "listview/label-today",
              key: Key("TimeWidget"),
            ),
          ]),
        ),
      );

      final textFinder = find.text("TODAY");
      final test = find.byKey(Key("TimeWidget")).evaluate();
      final test2 = find.byType(MaterialApp).evaluate();
      expect(textFinder, findsOneWidget);
    });
  });
}

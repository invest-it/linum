import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/domain/parsing/date_parser.dart';
import 'package:linum/screens/enter_screen/domain/parsing/structured_parsed_data_builder.dart';



List<StructuredParsedData> generateTestData() {
  final List<StructuredParsedData> testInputs = [];
  final dateParser = DateParser();

  var builder = StructuredParsedDataBuilder("9 EUR Döner #Food & Drinks")
    ..setAmount("9", 9)
    ..setCurrency("EUR", standardCurrencies["EUR"]!)
    ..setName("Döner")
    ..setCategory("#Food & Drinks", getCategory("food")!);

  testInputs.add(builder.build());

  builder = StructuredParsedDataBuilder("USD 12.00 Test #Date:28.07.")
    ..setAmount("12.00", 12.00)
    ..setCurrency("USD", standardCurrencies["USD"]!)
    ..setName("Test")
    ..setDate("#Date:28.07.", dateParser.parse("28.07.") ?? "null");
  testInputs.add(builder.build());


  builder = StructuredParsedDataBuilder("42 JPY Sushi #tdy #cat:Food & Drinks")
    ..setAmount("42", 42)
    ..setCurrency("JPY", standardCurrencies["JPY"]!)
    ..setName("Sushi")
    ..setDate("#tdy", dateParser.parse("tdy") ?? "null")
    ..setCategory("#cat:Food & Drinks", getCategory("food")!);
  testInputs.add(builder.build());

  return testInputs;
}

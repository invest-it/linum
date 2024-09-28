import 'package:linum/core/categories/core/domain/models/category.dart';
import 'package:linum/core/categories/core/domain/service_impl/category_service_standard_impl.dart';
import 'package:linum/core/categories/core/domain/types/category_map.dart';
import 'package:linum/features/currencies/core/constants/standard_currencies.dart';
import 'package:linum/screens/enter_screen/domain/models/structured_parsed_data.dart';
import 'package:linum/screens/enter_screen/domain/parsing/date_parser.dart';
import 'package:linum/screens/enter_screen/domain/parsing/structured_parsed_data_builder.dart';



List<StructuredParsedData> generateInputParserData() {
  final List<StructuredParsedData> testInputs = [];
  final dateParser = DateParser();

  final categoryService = CategoryServiceStandardImpl();
  final CategoryMap categories = categoryService.getAllCategories();

  var builder = StructuredParsedDataBuilder("9 EUR Döner #Food & Drinks")
    ..setAmount("9", 9)
    ..setCurrency("EUR", standardCurrencies["EUR"]!)
    ..setName("Döner")
    ..setCategory("#Food & Drinks", categories.getCategory("food")!);

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
    ..setCategory("#cat:Food & Drinks", categories.getCategory("food")!);
  testInputs.add(builder.build());

  builder = StructuredParsedDataBuilder("4200 JPY Sushi #tdy #cat:Food & Drinks")
    ..setAmount("4200", 4200)
    ..setCurrency("JPY", standardCurrencies["JPY"]!)
    ..setName("Sushi")
    ..setDate("#tdy", dateParser.parse("tdy") ?? "null")
    ..setCategory("#cat:Food & Drinks", categories.getCategory("food")!);
  testInputs.add(builder.build());

  return testInputs;
}

Map<String, Category?> getCategoryParserTestData(String? filterType) {
  final categoryService = CategoryServiceStandardImpl();
  final CategoryMap categories = categoryService.getAllCategories();

  final expenseCategories = <String, Category?>{
    // Expense
    "house": categories["house"],
    "Home & Living": categories["house"],
    "Lifestyle": categories["lifestyle"],
  };

  final incomeCategories = <String, Category?>{
    // Income
    "Side Job": categories["sidejob"],
    "Child Support": categories["childsupport"],
    "Investments": categories["investments"],
  };

  assert(filterType == "expense" || filterType == "income" || filterType == null);

  if (filterType == "expense") {
    return expenseCategories;
  }

  if (filterType == "income") {
    return incomeCategories;
  }

  if (filterType == null) {
    final data = <String, Category?> {};
    data.addAll(incomeCategories);
    data.addAll(expenseCategories);
    return data;
  }

  return {};
}

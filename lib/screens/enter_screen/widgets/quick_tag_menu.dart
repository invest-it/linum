import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/constants/standard_categories.dart';
import 'package:linum/core/categories/utils/translate_category.dart';
import 'package:linum/screens/enter_screen/utils/date_formatter.dart';
import 'package:linum/screens/enter_screen/utils/show_enter_screen_menu.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/buttons/tag_selector_button.dart';
import 'package:linum/screens/enter_screen/widgets/views/category_list_view.dart';
import 'package:linum/screens/enter_screen/widgets/views/currency_list_view.dart';
import 'package:linum/screens/enter_screen/widgets/views/repeat_config_list_view.dart';
import 'package:provider/provider.dart';

class QuickTagColors {
  final Color date;
  final Color category;
  final Color currency;
  final Color repeatInfo;
  const QuickTagColors({
    required this.date,
    required this.category,
    required this.currency,
    required this.repeatInfo,
  });
}

class QuickTagMenu extends StatefulWidget {
  final QuickTagColors colors;
  const QuickTagMenu({
    super.key,
    this.colors = const QuickTagColors(
      date: Color(0xFF88b6e1),
      category: Color(0xFFEE9645),
      currency: Color(0xFF97BC4E),
      repeatInfo: Color(0xFFDA7B7B),
    ),
  });

  @override
  State<QuickTagMenu> createState() => _QuickTagMenuState();
}

class _QuickTagMenuState extends State<QuickTagMenu> {
  final formatter = const DateFormatter();

  List<Widget> _buildButtons(EnterScreenFormViewModel formViewModel) {
    final currency = formViewModel.data.currency ?? formViewModel.defaultValues.currency;
    final category = formViewModel.data.category
        ?? (formViewModel.entryType == EntryType.expense
            ? formViewModel.defaultValues.expenseCategory
            : formViewModel.defaultValues.incomeCategory
        );
    final repeatConfiguration =
        formViewModel.data.repeatConfiguration ?? formViewModel.defaultValues.repeatConfiguration;

    return [
      TagSelectorButton(
        title: tr(
          formatter
            .format(formViewModel.data.date ?? formViewModel.defaultValues.date)
            ?? "",
        ), // TODO: Translate
        symbol: "",
        onTap: () => {print("Select Date")},
        textColor: widget.colors.date,
      ),
      TagSelectorButton(
        title: tr(currency.label),
        symbol: currency.symbol,
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: "Currencies",
            content: CurrencyListView(),
          );
        },
        textColor: widget.colors.currency,
      ),
      TagSelectorButton(
        title: translateCategory(category),
        symbol: "",
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: "Categories",
            content: CategoryListView(
              categories: standardCategories.values
                  .where((element) => element.entryType == formViewModel.entryType)
                  .toList(),
            ),
          );
        },
        textColor: widget.colors.category,
      ),
      TagSelectorButton(
        title: tr(repeatConfiguration.label),
        symbol: "",
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: "Repeating",
            content: RepeatConfigListView(),
          );
        },
        textColor: widget.colors.repeatInfo,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Consumer<EnterScreenFormViewModel>(builder: (
            context,
            formViewModel,
            _,
          ) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _buildButtons(formViewModel),
            );
          },),
        ),
      ],
    );
  }
}

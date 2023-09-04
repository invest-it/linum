import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/enums/entry_type.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/categories/core/utils/translate_category.dart';
import 'package:linum/generated/translation_keys.g.dart';
import 'package:linum/screens/enter_screen/domain/formatting/date_formatter.dart';
import 'package:linum/screens/enter_screen/presentation/utils/context_extensions.dart';
import 'package:linum/screens/enter_screen/presentation/utils/show_enter_screen_menu.dart';
import 'package:linum/screens/enter_screen/presentation/view_models/enter_screen_form_view_model.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/buttons/tag_selector_button.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/menu/category_list_view.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/menu/currency_list_view.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/menu/notes_view.dart';
import 'package:linum/screens/enter_screen/presentation/widgets/menu/repeat_config_list_view.dart';
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

class QuickTagMenu extends StatelessWidget {
  final QuickTagColors colors;
  final DateFormatter formatter;

  const QuickTagMenu({
    super.key,
    this.colors = const QuickTagColors(
      date: Color(0xFF88b6e1),
      category: Color(0xFFEE9645),
      currency: Color(0xFF97BC4E),
      repeatInfo: Color(0xFFDA7B7B),
    ),
    this.formatter = const DateFormatter(),
  });


  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Consumer<EnterScreenFormViewModel>(
            builder: (context, formViewModel, _,) {
              return Wrap(
                spacing: 5,
                runSpacing: 5,
                children: _buildButtons(context, formViewModel),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildButtons(BuildContext context, EnterScreenFormViewModel formViewModel) {
    final entryType = context.getEntryType();

    final currency = formViewModel.data.options.currency ?? formViewModel.defaultValues.currency;
    final category = formViewModel.data.options.category
        ?? (entryType == EntryType.expense
            ? formViewModel.defaultValues.expenseCategory
            : formViewModel.defaultValues.incomeCategory
        );
    final repeatConfiguration =
        formViewModel.data.options.repeatConfiguration ?? formViewModel.defaultValues.repeatConfiguration;
    final date = formViewModel.data.options.date ?? formViewModel.defaultValues.date;

    return [
      TagSelectorButton(
        title: tr(formatter.format(date) ?? ""),
        icon: Icons.calendar_today_outlined,
        onTap: () {
          final result = showDatePicker(
            context: context,
            initialDate: DateTime.parse(date),
            firstDate: DateTime(2000),
            lastDate: DateTime(DateTime.now().year + 5, 12),
          );
          result.then((value) {
            formViewModel.data = formViewModel.data.copyWithOptions(
              date: value?.toIso8601String(),
            );
          });
        },
        textColor: colors.date,
      ),
      TagSelectorButton(
        title: tr(currency.label),
        symbol: currency.symbol,
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: tr(translationKeys.enterScreen.menu.currency),
            content: CurrencyListView(),
          );
        },
        textColor: colors.currency,
      ),
      TagSelectorButton(
        title: translateCategory(category),
        icon: category?.icon,
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: tr(translationKeys.enterScreen.menu.category),
            content: CategoryListView(
              categories: standardCategories.values
                  .where((element) => element.entryType == entryType)
                  .toList(),
            ),
          );
        },
        textColor: colors.category,
      ),
      TagSelectorButton(
        title: tr(repeatConfiguration.label),
        icon: repeatConfiguration.icon,
        onTap: () {
          showEnterScreenMenu(
            context: context,
            title: tr(translationKeys.enterScreen.menu.repeatConfig),
            content: RepeatConfigListView(),
          );
        },
        textColor: colors.repeatInfo,
      ),
      TagSelectorButton(
        title: tr(translationKeys.enterScreen.menu.notes),
        icon: Icons.edit_outlined,
        onTap: () {
          showEnterScreenMenu(
            context: context,
            content: const NotesView(),
          );
        },
      )
    ];
  }


}

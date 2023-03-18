import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/core/categories/utils/translate_category.dart';
import 'package:linum/screens/enter_screen/utils/date_formatter.dart';
import 'package:linum/screens/enter_screen/viewmodels/enter_screen_view_model.dart';
import 'package:linum/screens/enter_screen/widgets/tag_selector_button.dart';
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

  List<Widget> _buildButtons(EnterScreenViewModel viewModel) {
    final currency = viewModel.data.currency ?? viewModel.defaultCurrency;
    final category = viewModel.data.category ?? viewModel.defaultCategory;
    final repeatConfiguration =
        viewModel.data.repeatConfiguration ?? viewModel.defaultRepeatConfiguration;
    return [
      TagSelectorButton(
        title: tr(
          formatter
            .format(viewModel.data.date ?? viewModel.defaultDate)
            ?? "",
        ), // TODO: Translate
        symbol: "",
        onTap: () => {print("Select Date")},
        textColor: widget.colors.date,
      ),
      TagSelectorButton(
        title: tr(currency.label),
        symbol: currency.symbol,
        onTap: () => {print("Select Currency")},
        textColor: widget.colors.currency,
      ),
      TagSelectorButton(
        title: translateCategory(category),
        symbol: "",
        onTap: () => {print("Select Category")},
        textColor: widget.colors.category,
      ),
      TagSelectorButton(
        title: tr(repeatConfiguration.label),
        symbol: "",
        onTap: () => {print("Select RepeatInfo")},
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
          child: Consumer<EnterScreenViewModel>(builder: (
            context,
            viewModel,
            _,
          ) {
            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _buildButtons(viewModel),
            );
          },),
        ),
      ],
    );
  }
}

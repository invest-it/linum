import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:linum/common/utils/silent_scroll.dart';
import 'package:linum/core/categories/core/constants/standard_categories.dart';
import 'package:linum/core/design/layout/enums/screen_fraction_enum.dart';
import 'package:linum/core/design/layout/utils/layout_helpers.dart';
import 'package:linum/features/currencies/core/utils/currency_formatter.dart';
import 'package:linum/features/currencies/settings/presentation/currency_settings_service.dart';
import 'package:linum/screens/statistics_screen/widgets/category_stats_pie_chart.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
// TODO: Perhaps rename if there is a even more detailed view in the future
class CategoryStatsDetailsView extends StatelessWidget {
  final List<CategoryStatistics<String>> stats;
  const CategoryStatsDetailsView({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ScrollConfiguration(
        behavior: const SilentScroll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: context.proportionateScreenWidthFraction(ScreenFraction.half),
                  height: context.proportionateScreenWidthFraction(ScreenFraction.half),
                  child: CategoryStatsPieChart(stats: stats),
                ),
              ),
            ),
            Text("CATEGORIES",
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.start,
            ), // TODO: Translate
            Expanded(
              child: ListView(
                children: stats.map((stat) {
                  return CategoryStatsDetailsViewItem(stat: stat);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryStatsDetailsViewItem extends StatelessWidget {
  final CategoryStatistics<String> stat;
  const CategoryStatsDetailsViewItem({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final category = standardCategories[stat.categoryId];
    if (category == null) {
      Logger().log(Level.error, "Category is null. This is not supposed to happen");
      return const Row();
    }

    final formatter = CurrencyFormatter(
      context.locale,
      symbol: context.watch<ICurrencySettingsService>().getStandardCurrency().symbol,
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      color: theme.colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: stat.color,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  category.icon,
                  color: stat.textColor,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(tr(category.label), style: theme.textTheme.headlineSmall,),
              ),
            ),
            Text(formatter.format(stat.amount), style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

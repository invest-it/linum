import 'package:flutter/material.dart';
import 'package:linum/core/balance/domain/models/transaction.dart';
import 'package:linum/core/categories/core/presentation/category_service.dart';
import 'package:linum/core/categories/core/utils/translate_category.dart';
import 'package:provider/provider.dart';

class TransactionTileTitle extends StatelessWidget {
  final Transaction transaction;
  final bool isFutureItem;

  const TransactionTileTitle({
    super.key,
    required this.transaction,
    required this.isFutureItem,
  });

  @override
  Widget build(BuildContext context) {
    final categoryIdTranslator = CategoryIdTranslator(
      categories: context.read<ICategoryService>().getAllCategories(),
    );

    final titleText = transaction.name != ""
        ? transaction.name
        : categoryIdTranslator.translate(
            transaction.category,
            isExpense: transaction.amount <= 0,
          );

    return Row(
      children: [
        Text(
          titleText,
          style: isFutureItem
              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface,
          )
              : Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 10,),
        transaction.note != null
            ? Badge(
                largeSize: 20,
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: const Icon(
                  Icons.edit_outlined,
                  size: 12,
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}

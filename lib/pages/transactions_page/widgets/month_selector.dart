import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/functions.dart';
import '../../../constants/style.dart';
import '../../../providers/transactions_provider.dart';
import '../../../utils/formatted_date_range.dart';

class MonthSelector extends ConsumerWidget with Functions {
  const MonthSelector({
    super.key,
  });

  final double height = 60;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmount = ref.watch(totalAmountProvider);
    final startDate = ref.watch(filterDateStartProvider);
    final endDate = ref.watch(filterDateEndProvider);
    return GestureDetector(
      onTap: () async {
        // pick range of dates
        DateTimeRange? range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(1970, 1, 1),
          lastDate: DateTime(2100, 12, 31),
          currentDate: DateTime.now(),
          initialDateRange: DateTimeRange(
            start: startDate,
            end: endDate,
          ),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              appBarTheme: Theme.of(context).appBarTheme.copyWith(backgroundColor: blue1),
            ),
            child: child!,
          ),
        );
        if (range != null) {
          ref.read(filterDateStartProvider.notifier).state = range.start;
          ref.read(filterDateEndProvider.notifier).state = range.end;
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias, // force rounded corners on children
        height: height,
        decoration: const BoxDecoration(
          color: blue7,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // move to previous month
                ref.read(filterDateStartProvider.notifier).state =
                    DateTime(startDate.year, startDate.month - 1, startDate.day);
                ref.read(filterDateEndProvider.notifier).state =
                    DateTime(startDate.year, startDate.month, 0);
                ref.read(transactionsProvider.notifier).filterTransactions();
              },
              child: Container(
                height: height,
                width: height,
                color: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  getFormattedDateRange(startDate, endDate),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: numToCurrency(totalAmount),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: totalAmount >= 0 ? green : red),
                      ),
                      TextSpan(
                        text: "€",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: totalAmount >= 0 ? green : red)
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // move to next month
                ref.read(filterDateStartProvider.notifier).state =
                    DateTime(startDate.year, startDate.month + 1, startDate.day);
                ref.read(filterDateEndProvider.notifier).state =
                    DateTime(startDate.year, startDate.month + 2, 0);
                ref.read(transactionsProvider.notifier).filterTransactions();
              },
              child: Container(
                height: height,
                width: height,
                color: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

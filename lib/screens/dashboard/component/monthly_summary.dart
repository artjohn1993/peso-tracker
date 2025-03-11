import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/main.dart';
import 'package:peso_tracker/provider/transaction_notifier.dart';
import 'package:peso_tracker/util/money_util.dart';
import 'package:peso_tracker/util/calendar_util.dart';

class MonthlySummary extends ConsumerStatefulWidget {
  const MonthlySummary({super.key});
  
  
  @override
  ConsumerState<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends ConsumerState<MonthlySummary> {
  late TransactionNotifier transactionNotifier;

  @override
  void initState() {
    super.initState();
    transactionNotifier = ref.read(transactionProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(transactionProvider);
    final totalIncome = transactionNotifier.getTotalIncome(DateTime.now());
    final totalExpenses = transactionNotifier.getTotalExpenses(DateTime.now());
    final balance = transactionNotifier.balance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${CalendarUtil.month} Summary',
              style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            const SizedBox(height: 8),
            const Text(
              'Balance',
              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 12),
            ),
            Text(
              MoneyUtil.formatTotal(balance),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(children: [
                  const Text(
                    'Income',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 22, 127, 26)),
                  ),
                  Text(
                    '₱${MoneyUtil.format(totalIncome)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: kIncomeColor),
                  ),
                ]),
                const Spacer(),
                Column(children: [
                  const Text(
                    'Expenses',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 157, 27, 18)),
                  ),
                  Text(
                    '₱${MoneyUtil.format(totalExpenses)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, color: kExpensesColor),
                  ),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}

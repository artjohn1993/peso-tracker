import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/dialog/filter_dialog.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/provider/filter_notifier.dart';
import 'package:peso_tracker/provider/transaction_notifier.dart';
import 'package:peso_tracker/screens/transaction/component/transaction_list.dart';
import 'package:peso_tracker/util/calendar_util.dart';
import 'package:peso_tracker/util/money_util.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  List<TransactionModel> transactionList = [];
  List<TransactionModel> filteredList = [];
  FilterType filterType = FilterType.month;
  late TransactionNotifier transactionNotifier;
  final today = DateTime.now();
  var filteredDate = DateTime.now();
  int currentMonth = 0;

  @override
  void initState() {
    super.initState();
    transactionNotifier = ref.read(transactionProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    transactionList = ref.watch(transactionProvider).toList();
    filterType = ref.watch(filterTypeProvider);
    filteredList = filterList();
    ref.watch(transactionProvider);
    var totalIncome = transactionNotifier.getTotalIncome(filteredDate);
    var totalExpenses = transactionNotifier.getTotalExpenses(filteredDate);
    var balance = transactionNotifier.balance;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                IconButton(
                    onPressed: previousMonth,
                    icon: const Icon(
                        Icons.navigate_before)), // previous month button
                Text(
                  CalendarUtil.getmonthYear(filteredDate),
                  style: const TextStyle(color: Colors.white54),
                ), // month and  year text
                IconButton(
                    onPressed: nextMonth,
                    icon: const Icon(Icons.navigate_next)),
                const Spacer(),
                IconButton(
                    onPressed: showFilterDialog,
                    icon: const Icon(Icons.filter_list_sharp)) // filter button
              ],
            ),
            const Text('Balance', style: TextStyle(fontSize: 12, color: Colors.white60),),
            Text(MoneyUtil.formatTotal(balance)), // total transaction
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'INCOME',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '₱${MoneyUtil.format(totalIncome)}',
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'EXPENSES',
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        '₱${MoneyUtil.format(totalExpenses)}',
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: TransactionList(
        transactionList: filteredList,
        updateTransaction: updateTransaction,
        removeTransaction: removeTransaction,
      ),
    );
  }

  void nextMonth() {
    currentMonth--;
    setState(() {
      filteredDate =
          DateTime(today.year, today.month - currentMonth, today.day);
    });
  }

  void previousMonth() {
    currentMonth++;
    setState(() {
      filteredDate =
          DateTime(today.year, today.month - currentMonth, today.day);
    });
  }

  void showFilterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext buildContext) => FilterDialog());
  }

  void removeTransaction(int index) {
      var removedItem = transactionList[index];
          transactionNotifier.removeTransaction(removedItem);
  }

  void updateTransaction(TransactionModel transaction, int index) {
    var element = filteredList[index];
    var transactionIndex = transactionList.indexOf(element);
    transactionList[transactionIndex] = transaction;
    ref
        .read(transactionProvider.notifier)
        .updateTransaction(transactionList, transactionIndex);
  }

  List<TransactionModel> filterList() {
    if (filterType == FilterType.income) {
      return transactionList
          .where((item) =>
              item.transactionType == TransactionType.income &&
              CalendarUtil.getmonthYear(item.date) ==
                  CalendarUtil.getmonthYear(filteredDate))
          .toList();
    } else if (filterType == FilterType.expenses) {
      return transactionList
          .where((item) =>
              item.transactionType == TransactionType.expenses &&
              CalendarUtil.getmonthYear(item.date) ==
                  CalendarUtil.getmonthYear(filteredDate))
          .toList();
    } else {
      return transactionList
          .where((item) =>
              CalendarUtil.getmonthYear(item.date) ==
              CalendarUtil.getmonthYear(filteredDate))
          .toList();
    }
  }
}

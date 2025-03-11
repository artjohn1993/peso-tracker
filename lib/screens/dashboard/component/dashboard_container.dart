// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/model/weekly_model.dart';
import 'package:peso_tracker/provider/transaction_notifier.dart';
import 'package:peso_tracker/screens/dashboard/component/bar_chart_transaction.dart';
import 'package:peso_tracker/screens/dashboard/component/monthly_summary.dart';
import 'package:peso_tracker/util/calendar_util.dart';

class DashboardContainer extends ConsumerStatefulWidget {
  const DashboardContainer({super.key});

  @override
  ConsumerState<DashboardContainer> createState() => _DashboardContainerState();
}

class _DashboardContainerState extends ConsumerState<DashboardContainer> {
  List<TransactionModel> transactionList = [];


  @override
  Widget build(BuildContext context) {
    transactionList = ref.watch(transactionProvider);
    print(transactionList);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        children: [
          MonthlySummary(),
          const SizedBox(height: 16),
          BarChartTransaction(weeklyTransaction: processWeeklyTransaction)
        ],
      ),
    );
  }

  List<WeeklyModel> get processWeeklyTransaction {
    var weekdays = CalendarUtil.weekday;
    List<WeeklyModel> weeklyTransaction = [];

    for (var weekday in weekdays) {
      var dayString = CalendarUtil.getYearMonthDay(weekday);

      var filteredList = [];
      for (var transactionItem in transactionList) {
        if (CalendarUtil.getmonthDayYear(transactionItem.date) == dayString) {
          filteredList.add(transactionItem);
        }
      }

      if (filteredList.isEmpty) {
        weeklyTransaction.add(WeeklyModel(income: 0, expenses: 0));
      } else {
        double income = 0;
        double expenses = 0;
        for (var filteredItem in filteredList) {
          if (filteredItem.transactionType == TransactionType.income) {
            income = income + filteredItem.amount;
          } else {
            expenses = expenses + filteredItem.amount;
          }
        }
        weeklyTransaction.add(WeeklyModel(income: income, expenses: expenses));
      }
    }
    return weeklyTransaction;
  }
}

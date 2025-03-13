import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/services/database_service.dart';
import 'package:peso_tracker/util/calendar_util.dart';

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]);
  final DatabaseService _database = DatabaseService.instance;

  void addTransaction(TransactionModel transaction) {
    var tempState = [transaction, ...state];
    tempState.sort((a, b) => b.date.compareTo(a.date));
    state = tempState;
    _database.addTransaction(transaction);
  }

  void updateTransaction(List<TransactionModel> list, int? index) {
    state = list;

    if (index != null) {
      _database.updateTransaction(state[index]);
    }

    state.sort((a, b) => b.date.compareTo(a.date));
  }

  void removeTransaction(TransactionModel transaction) {
    var filteredTransaction =
        state.where((item) => item.id != transaction.id).toList();
    state = filteredTransaction;
    _database.deleteTransaction(transaction);
  }

  void undo(List<TransactionModel> transactionlist) {
    state = transactionlist;
  }

  //will return the overall balance
  double get balance {
    var totalIncome = state
        .where((data) => data.transactionType == TransactionType.income)
        .fold(0.0, (total, income) => total + income.amount);

    var totalExpenses = state
        .where((data) => data.transactionType == TransactionType.expenses)
        .fold(0.0, (total, expenses) => total + expenses.amount);
    return totalIncome - totalExpenses;
  }

  //return total income of the selected month
  double getTotalIncome(DateTime date) {
    return state
        .where((data) =>
            data.transactionType == TransactionType.income &&
            CalendarUtil.getmonthYear(date) ==
                CalendarUtil.getmonthYear(data.date))
        .fold(0.0, (total, income) => total + income.amount);
  }

  //return total expenses of selected month
  double getTotalExpenses(DateTime date) {
    return state
        .where((data) =>
            data.transactionType == TransactionType.expenses &&
            CalendarUtil.getmonthYear(date) ==
                CalendarUtil.getmonthYear(data.date))
        .fold(0.0, (total, expenses) => total + expenses.amount);
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier();
});

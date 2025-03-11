import 'package:flutter/material.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/screens/transaction/component/transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.transactionList, required this.updateTransaction, required this.removeTransaction});

  final List<TransactionModel> transactionList;  
  final void Function(TransactionModel transaction, int index) updateTransaction;
  final void Function(int index) removeTransaction;
  @override
  Widget build(BuildContext context) {
    

    //if no available transaction display empty layout
    if (transactionList.isEmpty) {
      return const Center(
        child: Text('no available transaction'),
      );
    }

    return ListView.builder(
      itemCount: transactionList.length,
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        child: TransactionItem(
          transaction: transactionList[index],
          index: index,
          updateTransaction: updateTransaction,
        ),
        onDismissed: (direction) {
          //remove transaction
          removeTransaction(index);
        },
      ),
    );
  }

  
}

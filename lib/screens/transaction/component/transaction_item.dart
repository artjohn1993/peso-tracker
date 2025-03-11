import 'package:flutter/material.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/main.dart';
import 'package:peso_tracker/modal/transaction_modal.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/util/calendar_util.dart';
import 'package:peso_tracker/util/money_util.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
      {super.key,
      required this.transaction,
      required this.index,
      required this.updateTransaction});
  final TransactionModel transaction;

  final void Function(TransactionModel transaction, int index)
      updateTransaction;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () {
            editTransaction(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(CalendarUtil.getmonthDayYear(transaction.date))
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '₱${MoneyUtil.format(transaction.amount)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction.transactionType ==
                                  TransactionType.income
                              ? kIncomeColor
                              : kExpensesColor),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 16, left: 0),
                      child: Image(
                        image: AssetImage(transaction.category.imagepath),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.category.category.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Remarks: ${transaction.remarks}',
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            semanticsLabel: "Remarks",
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editTransaction(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (buildContext) => TransactionModal(
        transaction: transaction,
        index: index,
        updateTransaction: updateTransaction,
      ),
    );
  }
}

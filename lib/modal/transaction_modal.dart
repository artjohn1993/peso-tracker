import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/data/data.dart';
import 'package:peso_tracker/dialog/expenses_category_dialog.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/main.dart';
import 'package:peso_tracker/model/category_model.dart';
import 'package:peso_tracker/model/transaction_model.dart';
import 'package:peso_tracker/provider/transaction_notifier.dart';
import 'package:peso_tracker/util/calendar_util.dart';
import 'package:uuid/uuid.dart';

class TransactionModal extends ConsumerStatefulWidget {
  const TransactionModal(
      {super.key, this.transaction, this.index, this.updateTransaction});

  final int? index;
  final TransactionModel? transaction;
  final void Function(TransactionModel transaction, int index)?
      updateTransaction;
  @override
  ConsumerState<TransactionModal> createState() => _TransactionModalState();
}

class _TransactionModalState extends ConsumerState<TransactionModal> {
  var isTransactionIsIncome = true;
  var selectedCategory = categoryExpenses[0];
  final _formKey = GlobalKey<FormState>();
  double _amount = 0;
  String? _remarks;
  DateTime _selectedDate = DateTime.now();
  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
    changeTransaction();
    if (widget.transaction != null) {
      initializeTransaction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: openCalendar,
            child: Text(CalendarUtil.getmonthDayYear(_selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          ),
          Row(
            children: [
              Switch(
                value: isTransactionIsIncome,
                onChanged: (value) {
                  setState(() {
                    isTransactionIsIncome = value;
                  });
                  changeTransaction();
                },
                inactiveThumbColor: kExpensesColor,
                activeColor: kIncomeColor,
              ),
              const SizedBox(width: 16),
              Text(
                isTransactionIsIncome ? 'Income' : 'Expenses',
                style: TextStyle(
                    color:
                        isTransactionIsIncome ? kIncomeColor : kExpensesColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: showTransactionCategoryDialog,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image(
                        image: AssetImage(selectedCategory.imagepath),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      selectedCategory.category.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _amount == 0 ? "" : _amount.toString(),
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                        prefixText: '₱ ', label: Text('Amount')),
                    validator: (value) {
                      if (value == null || value == "") {
                        return 'Please put amount';
                      } else {
                        try {
                          double.parse(value);
                        } catch (e) {
                          return 'Invalid amount';
                        }
                        return null;
                      }
                    },
                    onSaved: (value) => _amount = double.parse(value!),
                  ),
                  TextFormField(
                    maxLength: 50,
                    initialValue: _remarks ?? "",
                    decoration: InputDecoration(label: Text('Remarks')),
                    onSaved: (newValue) => _remarks = newValue,
                  ),
                  widget.transaction == null
                      ? Row(
                          children: [
                            TextButton(
                                onPressed: _onReset, child: Text('Reset')),
                            SizedBox(width: 16),
                            ElevatedButton(
                                onPressed: _onSave, child: Text('Save')),
                          ],
                        )
                      : Row(
                          children: [
                            TextButton(
                                onPressed: (){Navigator.pop(context);}, child: Text('Close')),
                            SizedBox(width: 16),
                            ElevatedButton(
                                onPressed: _onUpdate, child: Text('Update')),
                          ],
                        )
                ],
              ))
        ],
      ),
    );
  }

  // save transaction to provider
  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ref.read(transactionProvider.notifier).addTransaction(TransactionModel(
          id: uuid.v1(),
          date: _selectedDate,
          remarks: _remarks,
          amount: _amount,
          transactionType: isTransactionIsIncome
              ? TransactionType.income
              : TransactionType.expenses,
          category: selectedCategory));
      Navigator.pop(context);
    }
  }

  void _onUpdate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.updateTransaction!(
        TransactionModel(
            id: _selectedDate.toString(),
            date: _selectedDate,
            remarks: _remarks,
            amount: _amount,
            transactionType: isTransactionIsIncome
                ? TransactionType.income
                : TransactionType.expenses,
            category: selectedCategory),
        widget.index!,
      );

      Navigator.pop(context);
    }
  }

  void _onReset() {
    _formKey.currentState!.reset();
  }

  //display the category
  void showTransactionCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext buildContext) => ExpensesCategoryDialog(
        selecteCategory: _selecteCategory,
        isTransactionIsIncome: isTransactionIsIncome,
      ),
    );
  }

  void _selecteCategory(CategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void initializeTransaction() {
    _amount = widget.transaction!.amount;
    _remarks = widget.transaction!.remarks;
    _selectedDate = widget.transaction!.date;
    selectedCategory = widget.transaction!.category;
    isTransactionIsIncome =
        widget.transaction!.transactionType == TransactionType.income;
  }

  void changeTransaction() {
    setState(() {
      selectedCategory =
          isTransactionIsIncome ? categoryIncome[0] : categoryExpenses[0];
    });
  }

  void openCalendar() async {
    final date = DateTime.now();
    final firstDate = DateTime(date.year - 1, date.month, date.day);
    final datePicked = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: date);

    if (datePicked != null) {
      setState(() {
        _selectedDate = datePicked;
      });
    }
  }
}

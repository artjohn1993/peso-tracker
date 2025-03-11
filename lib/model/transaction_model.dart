import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/model/category_model.dart';

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.date,
    required this.remarks,
    required this.amount,
    required this.transactionType,
    required this.category,
  });

  final String id;
  final DateTime date;
  final TransactionType transactionType;
  final String? remarks;
  final double amount;
  final CategoryModel category;
}

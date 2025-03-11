import 'package:flutter/material.dart';
import 'package:peso_tracker/data/data.dart';
import 'package:peso_tracker/model/category_model.dart';

class ExpensesCategoryDialog extends StatelessWidget {
  const ExpensesCategoryDialog(
      {super.key,
      required this.selecteCategory,
      required this.isTransactionIsIncome});

  final void Function(CategoryModel category) selecteCategory;
  final bool isTransactionIsIncome;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
            ),
            children: [
              for (var category in getCategory)
                InkWell(
                  key: ValueKey(category.category.index),
                  onTap: () {
                    Navigator.pop(context);
                    selecteCategory(category);
                  },
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(category.imagepath),
                        height: 30,
                        width: 30,
                      ),
                      Text(category.category.name)
                    ],
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  List<CategoryModel> get getCategory {
    return isTransactionIsIncome ? categoryIncome : categoryExpenses;
  }
}

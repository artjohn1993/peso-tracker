import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/enum/enum.dart';
import 'package:peso_tracker/provider/filter_notifier.dart';

class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  ConsumerState<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends ConsumerState<FilterDialog> {
  FilterType selectedFilter = FilterType.month;
  
  @override
  Widget build(BuildContext context) {
    selectedFilter = ref.read(filterTypeProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Filter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'By Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            ListTile(
              minTileHeight: 20,
              title: const Text("Month"),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.all(4),
              leading: Radio<FilterType>(
                value: FilterType.month,
                groupValue: selectedFilter,
                onChanged: (value) {
                  onSelectFilter(value!);
                },
              ),
            ),
            const SizedBox(height: 16), 
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'By Transaction',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            ListTile(
              minTileHeight: 20,
              title: const Text("Income"),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.all(4),
              leading: Radio<FilterType>(
                value: FilterType.income,
                groupValue: selectedFilter,
                onChanged: (value) {
                 onSelectFilter(value!);
                },
              ),
            ),
            ListTile(
              minTileHeight: 20,
              title: const Text("Expenses"),
              minVerticalPadding: 10,
              contentPadding: EdgeInsets.all(4),
              leading: Radio<FilterType>(
                value: FilterType.expenses,
                groupValue: selectedFilter,
                onChanged: (value) {
                  onSelectFilter(value!);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSelectFilter(FilterType type) {
    selectedFilter = type;
    ref.read(filterTypeProvider.notifier).changeFilter(selectedFilter);
    Navigator.of(context).pop();
  }
}

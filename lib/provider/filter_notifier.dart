import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peso_tracker/enum/enum.dart';

class FilterNotifier extends StateNotifier<FilterType>{
  FilterNotifier() : super(FilterType.month);

  void changeFilter(FilterType type) {
    state = type;
  }
}

final filterTypeProvider = StateNotifierProvider<FilterNotifier, FilterType>((ref){
  return FilterNotifier();
});

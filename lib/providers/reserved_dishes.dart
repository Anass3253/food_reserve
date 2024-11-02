import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_reserve/models/food_model.dart';

class ReservedDishesNotifier extends StateNotifier<List<Food>> {
  ReservedDishesNotifier() : super([]);

  bool reserveDishe(Food food) {
    final isExist = state.contains(food);

    if (isExist) {
      state = state.where((dishe) => dishe.id != food.id).toList();
      return false;
    } else {
      state = [...state, food];
      return true;
    }
  }

  int reservedFoodListLength () {
    return state.length;
  }
}

final reservedDisheProvider =
    StateNotifierProvider<ReservedDishesNotifier, List<Food>>(
  (ref) {
    return ReservedDishesNotifier();
  },
);

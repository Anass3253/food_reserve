import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_reserve/providers/login_signUp.dart';

class LikedDishesNotifier extends StateNotifier<List<String>> {
  LikedDishesNotifier(this.ref) : super([]);
  final Ref ref;
  bool isLiked() {
    final userId = ref.read(authenticationProvider);
    final isExist = state.contains(userId);

    if (isExist) {
      state = state.where((uId) => uId != userId).toList();
      return false;
    } else {
      state = [...state, userId];
      return true;
    }
  }
}

final likedDishesProvider =
    StateNotifierProvider<LikedDishesNotifier, List<String>>(
  (ref) => LikedDishesNotifier(ref),
);

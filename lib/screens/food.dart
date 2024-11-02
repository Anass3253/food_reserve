import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_reserve/models/food_model.dart';
import 'package:food_reserve/providers/reserved_dishes.dart';
import 'package:food_reserve/screens/checkout.dart';
import 'package:food_reserve/widgets/single_food.dart';
import 'package:searchfield/searchfield.dart';

class FoodScreen extends ConsumerStatefulWidget {
  const FoodScreen({super.key, required this.foodList});
  final List<Food> foodList;

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  final searchController = TextEditingController();
  List<Food> searchedDishe = [];
  var isSearched = false;
  int totall = 0;
  void _submitSearch(String value) {
    for (var food in widget.foodList) {
      value == food.title ? searchedDishe.add(food) : null;
    }
    setState(() {
      isSearched = true;
    });
  }

  void _resetSearch() {
    setState(() {
      isSearched = false;
      searchedDishe.clear();
      searchController.text = '';
    });
  }

  void _proccedToCheckout() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        final reservedDishes = ref.watch(reservedDisheProvider);
        return CheckoutScreen(reservedDishes: reservedDishes);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final totalll = ref.read(reservedDisheProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Reserve food!',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 30,
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: _proccedToCheckout,
                      icon: Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 30,
                      ),
                    ),
                    if (totalll.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        left: 30,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha(250),
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 2,
                            bottom: 2,
                          ),
                          child: Text(
                            totalll.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: SearchField<Food>(
                    hint: 'Search...',
                    suggestions: widget.foodList
                        .map(
                          (food) => SearchFieldListItem<Food>(
                            food.title,
                            item: food,
                            child: Text(food.title),
                          ),
                        )
                        .toList(),
                    controller: searchController,
                    itemHeight: 50,
                    onSubmit: (value) {
                      _submitSearch(value);
                    },
                  ),
                ),
              ),
              if (isSearched)
                IconButton(
                  onPressed: _resetSearch,
                  icon: const Icon(Icons.arrow_back),
                )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  isSearched ? searchedDishe.length : widget.foodList.length,
              itemBuilder: (context, index) {
                return SingleFood(
                  foodItem: isSearched
                      ? searchedDishe[index]
                      : widget.foodList[index],
                  onReserve: (totallReservedItems) {
                    setState(() {
                      totall = totallReservedItems;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

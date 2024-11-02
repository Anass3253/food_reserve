import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_reserve/models/food_model.dart';
import 'package:food_reserve/providers/liked_dishes.dart';
import 'package:food_reserve/providers/login_signUp.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:food_reserve/providers/reserved_dishes.dart';

class SingleFood extends ConsumerStatefulWidget {
  const SingleFood({
    super.key,
    required this.foodItem,
    required this.onReserve,
  });
  final Food foodItem;
  final void Function(int totallReservedItems) onReserve;

  @override
  ConsumerState<SingleFood> createState() => _SingleFoodState();
}

class _SingleFoodState extends ConsumerState<SingleFood> {
  bool isReservedIcon = false;
  int totallReservedItems = 0;
  void onReserveBtn() {
    final isAdded =
        ref.watch(reservedDisheProvider.notifier).reserveDishe(widget.foodItem);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAdded ? 'Dishe reserved!' : 'Dishe UnReserved!'),
      ),
    );
    if (isAdded) {
      widget.onReserve(totallReservedItems++);
    } else {
      widget.onReserve(totallReservedItems--);
    }
  }

  bool isLiked = false;
  /* @override
  void initState() async{
    
    super.initState();
  }*/
  void onLikedBtn() async {
    final userId = ref.watch(authenticationProvider);
    setState(() {
      isLiked = ref.watch(likedDishesProvider.notifier).isLiked();
      widget.foodItem.isFav = ref.watch(likedDishesProvider);
    });

    if (isLiked) {
      FirebaseFirestore.instance
          .collection('user-likes')
          .doc(widget.foodItem.id)
          .set({
        'liked': true,
        'user-id': userId,
        'dish-id': widget.foodItem.id,
        'dish-name': widget.foodItem.title,
      });
    }

    /*final userData = await FirebaseFirestore.instance
        .collection('user-likes')
        .doc(widget.foodItem.id)
        .get();
    
    if(userData.data() == null){
      return;
    }

    if(isLiked == false){
      userData.data()!.clear();
    }*/

    if (isLiked == false) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user-likes')
          .where('dish-id', isEqualTo: widget.foodItem.id)
          .get();
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }
  }

  void loadData() async {
    final userData = await FirebaseFirestore.instance
        .collection('user-likes')
        .doc(widget.foodItem.id)
        .get();

    if (userData.data() == null) {
      setState(() {
        isLiked = false;
      });
      return;
    }
    setState(() {
      isLiked = userData.data()!['liked'];
    });
    //isLiked = true;
  }

  @override
  Widget build(BuildContext context) {
    final addedDishe = ref.watch(reservedDisheProvider);
    if (addedDishe.contains(widget.foodItem)) {
      isReservedIcon = true;
    } else {
      isReservedIcon = false;
    }
    loadData();
    return Column(
      children: [
        Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () {},
            child: Stack(
              children: [
                Hero(
                  tag: widget.foodItem.id,
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(widget.foodItem.imageUrl),
                    height: 200,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color.fromARGB(143, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.foodItem.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          '\$ ${widget.foodItem.cost.toString()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onReserveBtn,
                icon: const Icon(Icons.add),
                label: const Text('Reserve'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(isReservedIcon
                      ? const Color.fromARGB(255, 130, 147, 231)
                      : Theme.of(context).colorScheme.secondary),
                ),
              ),
              if (isReservedIcon) const Icon(Icons.check_circle),
              IconButton(
                onPressed: onLikedBtn,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 35,
                ),
              ),
              if (widget.foodItem.isFav.isNotEmpty)
                Text(
                  widget.foodItem.isFav.length.toString(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

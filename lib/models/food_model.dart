import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Food {
  Food({
    required this.title,
    required this.cost,
    required this.imageUrl,
    String? id,
    required this.isFav,
  }) : id = id ?? uuid.v4();
  final String title;
  final double cost;
  final String imageUrl;
  final String id;
  List<String> isFav;
}

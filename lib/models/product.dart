import 'package:flutter/cupertino.dart';

class Product extends ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.isFavorite});

  void toggleIsFavStatus(){
    isFavorite=!isFavorite;
    notifyListeners();
  }
}

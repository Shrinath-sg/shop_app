import 'package:flutter/foundation.dart';

class CartItems {
  final String id;
  final String title;
  int quantity;
  double price;

  CartItems({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  int get itemCount => _items.length;

  void addItem(String prodId, String title, double price) {
    if (_items.containsKey(prodId)) {
      print('add...........ing');
      _items.update(
          prodId,
          (existingItem) => CartItems(
              id: existingItem.title,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity ++));
    } else {
      _items.putIfAbsent(prodId,
          () => CartItems(id: prodId, price: price, title: title, quantity: 1));
    }
    notifyListeners();
  }
  void deleteItem(productId){
    _items.remove(productId);
    notifyListeners();
  }
  void clearItems(){
    _items={};
    notifyListeners();
  }
  void removeSingleItem(prodId){
    if(_items.containsKey(prodId)){
      if(_items[prodId].quantity>1){
        _items.update(prodId, (existingCartItem) => CartItems(title: existingCartItem.title,id: existingCartItem.id,price: existingCartItem.price,quantity: existingCartItem.quantity-1));
      }
      else {
        _items.remove(prodId);
      }
      notifyListeners();
    }
    else return;
    notifyListeners();
  }
}

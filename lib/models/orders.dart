import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItems> orders;
  final DateTime date;

  OrderItem({this.id, this.amount, this.date, this.orders});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final url =
      Uri.https('shopapp-291a0-default-rtdb.firebaseio.com', '/Orders.json');

  Future<void> fetchAndSetOrders() async {
    final url2 =
    Uri.https('shopapp-291a0-default-rtdb.firebaseio.com', '/Orders.json');
    try {
      final response = await http.get(url2);
      print("!!!!!!!!!!!!!!!${json.decode(response.body)}");
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            date: DateTime.parse((orderData['date'])),
            orders: (orderData['orders'] as List<dynamic>)
                .map((item) => CartItems(
              id: item['id'],
              title: item['title'],
              price: item['price'],
              quantity: item['quantity'],
            )).toList()));
        _orders=loadedOrders;
        notifyListeners();
      });
    } catch (e) {
      print("fetchAndSet method error :${e.toString()}");
    }
  }

  Future<void> addOrder(List<CartItems> orderedProducts, double amount) async {
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'date': timeStamp.toIso8601String(),
            'amount': amount,
            'orders': orderedProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList(),
          }));
      print("@@@@@@@@@@@@@@@@@@@${response.statusCode}");
      notifyListeners();

      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              date: timeStamp,
              amount: amount,
              orders: orderedProducts));
      notifyListeners();
    } catch (err) {
      //  print("@@@@@@@@@@@@@@@@@@@$err");
      throw err;
    }
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopping_app/dummy_data/dummy_products.dart';
import 'package:shopping_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final String token;
  ProductsProvider(this.token,);
  List<Product> _items = [];

  List<Product> get items {
    // print("getter all items...................");
    print(_items);
    return [..._items];
  }

  List<Product> get favItems {
        // print("getter...................");
    // print(_items.where((element) => element.isFavorite == true).toList());
    return _items.where((item) => item.isFavorite == true).toList();
  }

  Product findItemByID(String routeItemId) {
    notifyListeners();
    return _items.firstWhere((item) => item.id == routeItemId);
  }

  final url =
      Uri.https('shopapp-291a0-default-rtdb.firebaseio.com', '/products.json');

  Future<void> updateFavProduct(String id,bool isfavorite) async{
    try {
      final urll = Uri.parse('https://shopapp-291a0-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(urll,
        body: json.encode({
          'isFavorite': isfavorite,
        }),headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },).then((value) => print('*******************${value.statusCode}'));
    }catch(e){
      //  print('@@@@@@@@@@@@@@@@@$e');
    }
  }

  Future<void> fetchProducts() async {
    final _url =
    Uri.https('shopapp-291a0-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(
        _url,
      );
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      print('!!!!!!!!!!!!!!!!!!!!!!!$decodedData');
      List<Product> fetchedProd = [];
      decodedData.forEach((prodId, prodData) {
        fetchedProd.add(Product(
            id: prodId,
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            description: prodData['description'],
            title: prodData['title']));
      });
      _items = fetchedProd;
      notifyListeners();
    } catch (e) {
      print("error in ProductProvider fetchProduct ${e.toString()}");
      throw (e.toString());
    }
  }

  Future<void> addProducts(Product product) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'price': product.price,
            'isFavorite': product.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: false);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      //  print("@@@@@@@@@@@@@@@@@@@$err");
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product product) async{
    try {
      final urll = Uri.parse('https://shopapp-291a0-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(urll,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite':product.isFavorite,
          }),headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },);
    }catch(e){
      print('@@@@@@@@@@@@@@@@@$e');
    }
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async{
    final _url = Uri.parse('https://shopapp-291a0-default-rtdb.firebaseio.com/products/$id.json');
    final backUpItemIndex= _items.indexWhere((element) => element.id==id);
    var backUpItem= _items[backUpItemIndex];
    _items.removeAt(backUpItemIndex);
    await http.delete(_url).then((response) {
      if (response.statusCode != 200) {
        _items.insert(backUpItemIndex, backUpItem);
        notifyListeners();
        throw Exception("Oops!! could not delete item");
        //backUpItem=null;
        // print('Successful');
      } else {
      backUpItem = null;
      print('Successful');
    }
    }).catchError((e){
    //  print('delete function error : ${e.toString()}');
      throw e.toString();
    });

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productDetailScreen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedItem =
        Provider.of<ProductsProvider>(context).findItemByID(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedItem.title),
      ),
      body: Column(children: [
        Container(
          height: 300,
          width: double.infinity,
          child: Hero(
            tag: loadedItem.id,
            child: Image.network(
              loadedItem.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text('${loadedItem.title}',style: Theme.of(context).textTheme.title,),
        SizedBox(
          height: 10,
        ),
        Text("${loadedItem.description}")
      ]),
    );
  }
}

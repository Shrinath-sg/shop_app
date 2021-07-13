import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';

class GridItem extends StatelessWidget {
//   final String id;
//   final String title;
//
//   // final String description;
//   // final double price;
//   final String imageUrl;
//
// // bool isFavorite;
//   GridItem({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final _cart = Provider.of<Cart>(context);
    print("isExcecuted........?");
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: product.id),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (context, value, _) => InkWell(
                onTap: () async{
                  value.toggleIsFavStatus();
                 Provider.of<ProductsProvider>(context,listen: false).updateFavProduct(product.id, value.isFavorite);
                },
                child: Icon(
                  value.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            trailing: InkWell(
              child: Icon(Icons.shopping_cart,
                  color: Theme.of(context).accentColor),
              onTap: () {
                _cart.addItem(product.id, product.title, product.price);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 1500),
                    backgroundColor: Colors.green,
                    content: Text("Added item to cart"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        _cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
                // _cart.removeSingleItem(product.id);
              },
            ),
          ),
        ),
      ),
    );
  }
}

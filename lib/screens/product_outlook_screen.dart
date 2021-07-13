import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/badge_icon.dart';
import 'package:shopping_app/widgets/grid_item.dart';

enum optionValue { favorites, all }

class ProductOutlookScreen extends StatefulWidget {
  static const routeName='/ProductOutlookScreen';
  @override
  _ProductOutlookScreenState createState() => _ProductOutlookScreenState();
}

class _ProductOutlookScreenState extends State<ProductOutlookScreen> {
  bool togglFav = false;
  bool isLoading, isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchProducts()
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    dynamic productData = Provider.of<ProductsProvider>(context);
    List<Product> productList =
        togglFav ? productData.favItems : productData.items;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My shop"),
        actions: [
          PopupMenuButton(
            onSelected: (optionValue onSelected) {
              setState(() {
                if (onSelected == optionValue.favorites) {
                  togglFav = true;
                } else {
                  togglFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: optionValue.favorites,
              ),
              PopupMenuItem(
                child: Text("All"),
                value: optionValue.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () =>
                      Navigator.pushNamed(context, CartScreen.routeName),
                ),
                value: cartData.itemCount.toString()),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 5 / 4,
                mainAxisSpacing: 10,
              ),
              itemCount: productList.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                    value: productList[index],
                    child:
                        // create: (ctx)=>productList[index],
                        GridItem(),
                  )),
      drawer: CustomDrawer(),
    );
  }
}

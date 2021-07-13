import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_app/models/orders.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/widgets/cart_item_list.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        centerTitle: true,
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontSize: 18, fontFamily: "Lato"),
                ),
                Spacer(),
                Chip(
                  backgroundColor: Theme.of(context).primaryColor,
                  label: Text(
                    "\$${(cart.totalPrice.toStringAsFixed(2))}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () async{
                    if(cart.items.isNotEmpty){
                    Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(), cart.totalPrice);
                    cart.clearItems();
                    }
                    else{
                      showDialog(context: context, builder: (ctx)=>AlertDialog(
                        title: Text("No item added to cart"),
                      //  content: Text("Do you want to remove item from cart?"),
                        actions: [
                         // ElevatedButton(onPressed: (){Navigator.pop(ctx);}, child: Text('Yes'),),
                          ElevatedButton(onPressed: (){Navigator.pop(ctx,);}, child: Text('Ok'))
                        ],
                      ));
                    }
                  },
                  child: Shimmer.fromColors(
                      baseColor: Colors.deepOrange,
                      highlightColor: Colors.yellowAccent,
                      period: Duration(milliseconds: 1000),
                      child: Text(
                        "Order Now",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => CartItemList(
            quantity: cart.items.values.toList()[index].quantity,
            title: cart.items.values.toList()[index].title,
            id: cart.items.values.toList()[index].id,
            price: cart.items.values.toList()[index].price,
            keyId: cart.items.keys.toList()[index],
          ),
          itemCount: cart.itemCount,
        ))
      ]),
    );
  }
}

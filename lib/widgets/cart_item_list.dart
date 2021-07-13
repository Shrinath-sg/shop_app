import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItemList extends StatefulWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String keyId;

  CartItemList({this.quantity, this.price, this.title, this.id,this.keyId});

  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.keyId),
      direction: DismissDirection.endToStart,
      background: Container(
          padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            size: 40,
            color: Colors.white,
          )),
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx)=>AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove item from cart?"),
          actions: [
            ElevatedButton(onPressed: (){Navigator.pop(ctx,true);}, child: Text('Yes'),),
            ElevatedButton(onPressed: (){Navigator.pop(ctx,false);}, child: Text('No'))
          ],
        ));
      },
      onDismissed: (direction){
        Provider.of<Cart>(context,listen: false).deleteItem(widget.keyId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text("\$${widget.price}"))),
            ),
            title: Text(widget.title),
            subtitle: Text("Total: \$${widget.price * widget.quantity}"),
            trailing: Text("${widget.quantity} x"),
          ),
        ),
      ),
    );
  }
}

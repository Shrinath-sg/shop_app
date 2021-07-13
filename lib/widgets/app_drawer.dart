import 'package:flutter/material.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_outlook_screen.dart';
import 'package:shopping_app/screens/user_product_screen.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello Jack"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProductOutlookScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Orders"),
            onTap: (){Navigator.pushReplacementNamed(context, OrdersScreen.routName);},
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: (){Navigator.pushReplacementNamed(context, UserProductScreen.routeName);},
          )

        ],
      ),
    );
  }
}

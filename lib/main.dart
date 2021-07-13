import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/orders.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products_provider.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_or_add.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_detail_screen.dart';
import 'package:shopping_app/screens/product_outlook_screen.dart';
import 'package:shopping_app/screens/user_product_screen.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => ProductsProvider(Provider.of<Auth>(context,listen: false).token)),
        ChangeNotifierProvider(create: (context)=> Cart()),
        ChangeNotifierProvider(create: (context)=> Orders())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        home: Consumer<Auth>(builder: (ctx, value, _) {
          return  value.auth?ProductOutlookScreen():AuthScreen();
        },),
        routes: {
          ProductOutlookScreen.routeName:(context)=>ProductOutlookScreen(),
          AuthScreen.routeName:(context)=>AuthScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context)=> CartScreen(),
          OrdersScreen.routName: (context)=> OrdersScreen(),
          UserProductScreen.routeName: (context)=> UserProductScreen(),
          EditOrAdd.routeName: (context)=> EditOrAdd()
        },
      ),
    );
  }
}

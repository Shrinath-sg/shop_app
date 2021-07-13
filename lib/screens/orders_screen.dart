import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/orders.dart' show Orders;
import 'package:shopping_app/screens/edit_or_add.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/orderItem.dart';

class OrdersScreen extends StatefulWidget {
  static const routName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _futureData;
  Future _future(){
    return  Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
@override
  void initState() {
    _futureData=_future();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  //  final ordeData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditOrAdd.routeName);
            },
          )
        ],
        title: Text("Your orders"),
      ),
      body: FutureBuilder(
        future: _futureData,
        builder: (ctx, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError) {
            return Center(child: Text('Error Occurred'),);
          }
          return Consumer<Orders>(builder: (ctc, orderData, child) {
           return ListView.builder(
              itemBuilder: (context, index) =>
                  OrderItem(orderData.orders[index]),
              itemCount: orderData.orders.length,
            );
          },
          );
        },
      ),
    );
  }
}

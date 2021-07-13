import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/models/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;

  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}
class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.orderItem.amount.toString(),
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
                DateFormat("dd/mm/yyyy hh:mm").format(widget.orderItem.date)),
            trailing: IconButton(
              icon: isExpanded
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Container(
              height: min(widget.orderItem.orders.length * 35.0, 100.0),
              child: ListView(
                children: widget.orderItem.orders
                    .map((e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: width * 0.40,
                               // color: Colors.lightBlue,
                                child: Text(e.title)),
                            Container(
                                width: width * 0.40,
                               // color: Colors.red,
                                child: Text("${e.quantity} x \$${e.price}")),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}

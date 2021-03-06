import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shoppingapp/models/order_item.dart' as orderI;

class OrderItem extends StatefulWidget {
  final orderI.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: min(widget.order.products.length * 20.0 + 30, 100),
            child: ListView(
              children: widget.order.products.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${prod.quantity}x \$ ${prod.price}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ]
              )).toList(),

            ),
          ),
        ],
      ),
    );
  }
}

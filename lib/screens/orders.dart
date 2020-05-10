import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/orders.dart' as order;
import 'package:shoppingapp/widgets/app_drawer.dart';
import 'package:shoppingapp/widgets/order_item.dart';


class Orders extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<order.Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) => OrderItem(orderData.orders[index]),
      ),
    );
  }
}

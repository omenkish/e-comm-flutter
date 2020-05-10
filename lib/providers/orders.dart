import 'package:flutter/foundation.dart';

import 'package:shoppingapp/models/order_item.dart';
import 'package:shoppingapp/models/cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(0, OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      products: cartProducts,
      dateTime: DateTime.now()));
    notifyListeners();
  }
}
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shoppingapp/models/order_item.dart';
import 'package:shoppingapp/models/cart_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    final url = 'https://flutter-shopping-app-a9ef1.firebaseio.com/orders.json';
    final time = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount': total,
      'dateTime': time.toIso8601String(),
      'products': cartProducts.map((prod) => {
        'id': prod.id,
        'title': prod.title,
        'quantity': prod.quantity,
        'price': prod.price,
      }).toList(),
    }));

    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      products: cartProducts,
      dateTime: time,
    ));
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-shopping-app-a9ef1.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];

      if (extractedData == null) return;

      extractedData.forEach((key, value) {
        loadedOrders.add(
            OrderItem(
              id: key,
              amount: value['amount'],
              dateTime: DateTime.parse(value['dateTime']),
              products: (value['products'] as List<dynamic>).map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              )).toList(),
            ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error){
      throw error;
    }
  }
}
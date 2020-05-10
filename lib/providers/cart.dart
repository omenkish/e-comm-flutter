import 'package:flutter/foundation.dart';
import 'package:shoppingapp/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;

    _items.forEach((key, cartItem) {
      total += cartItem.price;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price + price,
      )
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
           id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        )
      );
    }
    notifyListeners();
  }
}

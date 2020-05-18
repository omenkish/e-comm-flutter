import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shoppingapp/models/http_exception.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus() async {
    var oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    final url = 'https://flutter-shopping-app-a9ef1.firebaseio.com/products/$id.json';
    final response = await http.patch(url, body: json.encode({
      'isFavourite': isFavourite,
    }));

    if (response.statusCode >= 400) {
      isFavourite = oldStatus;
      notifyListeners();
      throw HttpException('Unable to favourite at this time.');
    }

    oldStatus = null;
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoppingapp/providers/products.dart';
import 'package:shoppingapp/screens/product_details.dart';
import 'package:shoppingapp/screens/products_overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverview(),
        routes: {
          ProductDetails.routeName: (ctx) => ProductDetails(),
        },
      ),
    );
  }
}

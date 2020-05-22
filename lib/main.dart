import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/auth.dart';

import 'package:shoppingapp/providers/cart.dart';
import 'package:shoppingapp/providers/orders.dart';
import 'package:shoppingapp/providers/products.dart';
import 'package:shoppingapp/screens/auth.dart';
import 'package:shoppingapp/screens/cart.dart';
import 'package:shoppingapp/screens/edit_product.dart';
import 'package:shoppingapp/screens/orders.dart' as screen;
import 'package:shoppingapp/screens/product_details.dart';
import 'package:shoppingapp/screens/products_overview.dart';
import 'package:shoppingapp/screens/user_products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, prevProducts) => Products(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.items
          )
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, prevOrders) => prevOrders..setToken(auth.token)
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuthenticated ? ProductsOverview() : AuthScreen(),
          routes: {

            ProductDetails.routeName: (ctx) => ProductDetails(),
            CartScreen.routeName: (ctx) => CartScreen(),
            screen.Orders.routeName: (ctx) => screen.Orders(),
            UserProducts.routeName: (ctx) => UserProducts(),
            EditProduct.routeName: (ctx) => EditProduct(),
          },
        ),
      ),
    );
  }
}

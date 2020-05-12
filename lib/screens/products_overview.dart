import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/cart.dart';
import 'package:shoppingapp/providers/products.dart';
import 'package:shoppingapp/screens/cart.dart';
import 'package:shoppingapp/widgets/app_drawer.dart';
import 'package:shoppingapp/widgets/badge.dart';

import 'package:shoppingapp/widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All
}

class ProductsOverview extends StatefulWidget {

  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool _showOnlyFavourites = false;
  bool _isLoading = false;
  bool _loadingError = false;

  void fetchProducts () {
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchAndSetProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      setState(() {
        _loadingError = true;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Only Favourites'), value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ]
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ( _loadingError ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Something went wrong, please try again later!'),
            SizedBox(height: 12.0),
            FlatButton.icon(
              icon: Icon(Icons.refresh),
              label: Text('Click to refresh!'),
              onPressed: () {
                fetchProducts();
              },
            ),
          ],
        ),
      ) : ProductsGrid(_showOnlyFavourites)),
    );
  }
}

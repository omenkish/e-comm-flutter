import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoppingapp/providers/products.dart';
import 'package:shoppingapp/screens/edit_product.dart';
import 'package:shoppingapp/widgets/app_drawer.dart';
import 'package:shoppingapp/widgets/user_product_item.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProduct.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, productsData, _) => Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.items.length,
                itemBuilder: (_, idx) => Column(
                  children: <Widget>[
                    UserProductItem(
                      id: productsData.items[idx].id,
                      title: productsData.items[idx].title,
                      imageUrl: productsData.items[idx].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
                ),
              ),
            ),
        ),
      ),
    );
  }
}

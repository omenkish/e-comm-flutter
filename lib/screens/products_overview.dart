import 'package:flutter/material.dart';

import 'package:shoppingapp/widgets/products_grid.dart';

class ProductsOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: ProductsGrid(),
    );
  }
}

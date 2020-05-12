import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/providers/products.dart';
import 'package:shoppingapp/screens/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem({this.title, this.imageUrl, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, EditProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context, builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove this item?'),
                  actions: <Widget>[
                    FlatButton.icon(
                      color: Colors.grey,
                      icon: Icon(Icons.cancel, color: Colors.white,),
                      label: Text('No', style: TextStyle(color: Colors.white),),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton.icon(
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      label: Text('Yes'),
                      onPressed: () {
                        Provider.of<Products>(context, listen: false).deleteProduct(id);
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}

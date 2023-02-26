import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/product_provider.dart';
import '../widgets/user_product_items.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            }, 
            icon: const Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, index) => 
            Column(
              children: <Widget>[
                UserProductItem(
                  id: productsData.items[index].id as String,
                  title: productsData.items[index].title, 
                  imageUrl: productsData.items[index].imageUrl
                ),
                const Divider()
              ],
            )
        ),
      ),
    );
  }
}
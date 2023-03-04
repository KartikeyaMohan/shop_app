import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../enums/filter_options.dart';
import '../providers/product_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

class ProductsOverviewScreen extends StatefulWidget {

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _isLoading = true;
      Provider.of<ProductProvider>(context)
        .fetchAndSetProducts().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FilterOptions.FAVOURITES) {
                  _showOnlyFavourites = true;
                }
                else {
                  _showOnlyFavourites = false;
                }
              })
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: FilterOptions.FAVOURITES,child: Text('Only favourites'),),
              const PopupMenuItem(value: FilterOptions.ALL,child: Text('Show all'),)
            ]
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: ch ?? const Icon(Icons.shopping_cart)
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(
                Icons.shopping_cart
              ),
            )
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? 
        const Center(
          child: CircularProgressIndicator(),
        ) : 
        ProductsGrid(showOnlyFavourites: _showOnlyFavourites,),
    );
  }
}
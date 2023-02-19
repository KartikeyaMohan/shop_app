import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/filter_options.dart';
import '../providers/product_provider.dart';
import '../widgets/products_grid.dart';

class ProductsOverviewScreen extends StatefulWidget {

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProvider>(context);
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
            ]),
        ],
      ),
      body: ProductsGrid(showOnlyFavourites: _showOnlyFavourites,),
    );
  }
}
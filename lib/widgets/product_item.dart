import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {

  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: GridTile(
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavourite ? Icons.favorite: Icons.favorite_border),
                onPressed: () { 
                  product.toggleFavouriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
    );
  }
}
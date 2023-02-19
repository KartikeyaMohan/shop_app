import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {

  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key}); 

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct = Provider.of<ProductProvider>(
      context,
      listen: false
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title)
      ), 
    );
  }
}
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/product_provider.dart';
import './screens/cart_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart()
        )
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen()
        },
      ),
    );
  }
}

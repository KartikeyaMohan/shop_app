import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/product_provider.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (ctx, auth, previousProducts) => ProductProvider().update(
            auth.token, 
            previousProducts == null ? [] : previousProducts.items,
            auth.userId
          ),
          create: (ctx) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrders) => Orders().update(
            auth.token, 
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId
          ),
          create: (ctx) => Orders(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'
          ),
          home: auth.isAuth ? const ProductsOverviewScreen() : 
            FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResultSnapshot) => 
                authResultSnapshot.connectionState == ConnectionState.waiting ?
                  const SplashScreen() : const AuthScreen(),
            ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      )
    );
  }
}

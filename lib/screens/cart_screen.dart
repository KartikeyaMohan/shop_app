import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Total', style: TextStyle(fontSize: 20),),
                  const Spacer(), 
                  Chip(
                    label: Text(
                      '₹${cart.totalAmount}', 
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleMedium?.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {}, 
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.titleMedium?.color),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) => 
                CartItem(
                  id: cart.items.values.toList()[index].id, 
                  price: cart.items.values.toList()[index].price, 
                  quantity: cart.items.values.toList()[index].quantity, 
                  title: cart.items.values.toList()[index].title
                )
              ),
              itemCount: cart.items.length,
            )
          )
        ],
      ),
    );
  }
}
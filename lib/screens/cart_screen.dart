import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

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
                      '₹${cart.totalAmount.toStringAsFixed(2)}', 
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleMedium?.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
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
                  productId: cart.items.keys.toList()[index],
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

class OrderButton extends StatefulWidget {

  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading ? 
      const CircularProgressIndicator() : 
      TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading) ? null : () async {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount
          );
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        }, 
        child: const Text(
          'ORDER NOW',
          style: TextStyle(color: Colors.purple),
        ),
      );
  }
}
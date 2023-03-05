import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/order_item.dart';
import '../models/cart_item.dart';

class Orders with ChangeNotifier {

  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;

  Orders update(authToken, orders, userId) {
    this.authToken = authToken;
    _orders = orders;
    this.userId = userId;
    return this;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts.map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price
        }).toList()
      })
    );
    _orders.insert(
      0, 
      OrderItem(
        id: json.decode(response.body)['name'], 
        amount: total, 
        products: cartProducts, 
        dateTime: DateTime.now()
      )
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    extractedData?.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId, 
          amount: orderData['amount'], 
          products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'], 
                title: item['title'], 
                price: item['price'], 
                quantity: item['quantity']
              )
            ).toList(), 
          dateTime: DateTime.parse(orderData['dateTime'])
        )
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import './product.dart';

class ProductProvider with ChangeNotifier {

  List<Product> _items = [];
  
  String? authToken;
  String? userId;

  ProductProvider update(authToken, items, userId) {
    this.authToken = authToken;
    this.userId = userId;
    _items = items;
    return this;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }


  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(
        Uri.parse(url)
      );
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite: favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl']
        ));
      });
      _items = loadedProducts;
      notifyListeners(); 
    }
    catch(error) {
      rethrow;
    }
   }

  Future<void> addProduct(Product product) async {
    final url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url), 
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId
        })
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name']
      );
      _items.add(newProduct);
      notifyListeners();
    }
    catch(error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id,
                     Product newProduct) async {
    final url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/products/$id.json?auth=$authToken';
    final prodIndex = _items.indexWhere((product) => product.id == id);
    if (prodIndex >= 0) {
      await http.patch(
      Uri.parse(url),
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price
      })
    );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://react-projects-a8b61-default-rtdb.asia-southeast1.firebasedatabase.app/flutter_shop/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex] as Product?;
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct as Product);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
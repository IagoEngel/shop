import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/dummy_data.dart';
import 'product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = 'https://shop-c7e80-default-rtdb.firebaseio.com';

  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favouritesItems =>
      _items.where((prod) => prod.isFavourite).toList();

  int get itemsCount => _items.length;

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      value: data['value'] as double,
      imageUrl: data['url'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) {
    final future = http.post(
      Uri.parse('$_baseUrl/products'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'value': product.value,
        'imageUrl': product.imageUrl,
        'isFavourite': product.isFavourite,
      }),
    );

    return future.then((response) {
      final id = jsonDecode(response.body)['name'];

      _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        value: product.value,
        imageUrl: product.imageUrl,
      ));

      notifyListeners();
    });
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }

    return Future.value();
  }

  // bool _showFavourites = false;

  // List<Product> get items {
  //   if (_showFavourites) {
  //     return _items.where((prod) => prod.isFavourite).toList();
  //   } else {
  //     return [..._items];
  //   }
  // }

  // void showFavourites() {
  //   _showFavourites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavourites = false;
  //   notifyListeners();
  // }
}

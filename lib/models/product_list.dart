import 'dart:math';

import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import 'product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favouritesItems =>
      _items.where((prod) => prod.isFavourite).toList();

  int get itemsCount => _items.length;

  void addProductFromData(Map<String, Object> data) {
    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      value: data['value'] as double,
      imageUrl: data['url'] as String,
    );

    addProduct(newProduct);
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
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

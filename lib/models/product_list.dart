import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';
import '../utils/constants.dart';
import 'product.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = Constants.productsBaseUrl;

  final List<Product> _items = [];

  List<Product> get items => [..._items];
  List<Product> get favouritesItems =>
      _items.where((prod) => prod.isFavourite).toList();

  int get itemsCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse('$_baseUrl.json'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productValue) {
      _items.add(
        Product(
          id: productId,
          name: productValue['name'],
          description: productValue['description'],
          value: productValue['value'],
          imageUrl: productValue['imageUrl'],
        ),
      );
    });
    notifyListeners();
  }

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

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json'),
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'value': product.value,
        'imageUrl': product.imageUrl,
        'isFavourite': product.isFavourite,
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      value: product.value,
      imageUrl: product.imageUrl,
    ));

    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json'),
        body: jsonEncode({
          'name': product.name,
          'description': product.description,
          'value': product.value,
          'imageUrl': product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${product.id}.json'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluir o produto',
          statusCode: response.statusCode,
        );
      }
    }
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

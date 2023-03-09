import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double value;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void _toogleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toogleFavourite() async {
    try {
      _toogleFavourite();

      final response = await http.patch(
        Uri.parse('${Constants.productsBaseUrl}/$id.json'),
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );

      if (response.statusCode >= 400) {
        _toogleFavourite();
      }

    } catch (_) {
      _toogleFavourite();
    }
  }
}

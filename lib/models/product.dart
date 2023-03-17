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

  void _toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toggleFavourite(String token) async {
    try {
      _toggleFavourite();

      final response = await http.patch(
        Uri.parse('${Constants.productsBaseUrl}/$id.json?auth=$token'),
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );

      if (response.statusCode >= 400) {
        _toggleFavourite();
      }
    } catch (_) {
      _toggleFavourite();
    }
  }
}

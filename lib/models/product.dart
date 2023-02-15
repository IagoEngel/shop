import 'package:flutter/material.dart';

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

  void toogleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}

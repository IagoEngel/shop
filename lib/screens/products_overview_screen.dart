import 'package:flutter/material.dart';

import '../components/product_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Minha loja!'),
      ),
      body: const ProductGrid(),
    );
  }
}
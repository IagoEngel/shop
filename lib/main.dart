import 'package:flutter/material.dart';
// import 'providers/counter.dart';
// import 'screens/counter_page.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return CounterProvider(
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: const ColorScheme.light().copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato'),
      home: ProductsOverviewScreen(),
      routes: {
        AppRoutes.productDetail: (context) => const ProductDetailScreen(),
        // AppRoutes.productDetail: (context) => const CounterPage(),
      },
    );
    // );
  }
}

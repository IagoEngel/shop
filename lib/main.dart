import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
// import 'providers/counter.dart';
// import 'screens/counter_page.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return CounterProvider(
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: const ColorScheme.light().copyWith(
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato'),
        // home: const ProductsOverviewScreen(),
        routes: {
          AppRoutes.auth:(context) => const AuthScreen(),
          AppRoutes.home: (_) => const ProductsOverviewScreen(),
          AppRoutes.productDetail: (_) => const ProductDetailScreen(),
          // AppRoutes.productDetail: (context) => const CounterPage(),
          AppRoutes.cart: (_) => const CartScreen(),
          AppRoutes.orders: (_) => const OrdersScreen(),
          AppRoutes.products: (_) => const ProductsScreen(),
          AppRoutes.productForm: (_) => const ProductFormScreen(),
        },
      ),
    );
    // );
  }
}

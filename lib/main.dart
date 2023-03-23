import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/auth.dart';
import 'models/cart.dart';
import 'models/order_list.dart';
import 'models/product_list.dart';
// import 'providers/counter.dart';
// import 'screens/counter_page.dart';
import 'screens/auth_or_home.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_form_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/products_screen.dart';
import 'utils/app_routes.dart';
import 'utils/custom_route.dart';

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
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (context, auth, previousProductList) => ProductList(
            auth.token ?? '',
            auth.userId ?? '',
            previousProductList?.items ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previousOrderList) => OrderList(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrderList?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
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
          fontFamily: 'Lato',
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
              TargetPlatform.android: CustomPageTransitionsBuilder(),
            },
          ),
        ),
        // home: const ProductsOverviewScreen(),
        routes: {
          AppRoutes.authOrHome: (_) => const AuthOrHomeScreen(),
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

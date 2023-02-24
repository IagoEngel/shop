import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/order.dart';
import '../models/order_list.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orderList = Provider.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Meus Pedidos'),
      ),
      body: ListView.builder(
        itemCount: orderList.itemCount,
        itemBuilder: (_, index) => OrderWidget(order: orderList.items[index]),
      ),
    );
  }
}

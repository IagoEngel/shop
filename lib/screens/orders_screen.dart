import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_drawer.dart';
import '../components/order.dart';
import '../models/order_list.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Meus Pedidos'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<OrderList>(context, listen: false).loadProducts(),
        child: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Ocorreu um erro'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (context, orderList, _) {
                  return ListView.builder(
                    itemCount: orderList.itemCount,
                    itemBuilder: (_, index) =>
                        OrderWidget(order: orderList.items[index]),
                  );
                }
              );
            }
          },
        ),
      ),
    );
  }
}

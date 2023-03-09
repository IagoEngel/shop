import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'cart.dart';
import 'cart_item.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemCount => _items.length;

  Future<void> loadProducts() async {
    _items.clear();

    final response =
        await http.get(Uri.parse('${Constants.ordersBaseUrl}.json'));

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderValue) {
      _items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderValue['date']),
          total: orderValue['total'],
          products: (orderValue['products'] as List)
              .map(
                (cartItem) => CartItem(
                  id: cartItem['id'],
                  name: cartItem['name'],
                  price: cartItem['price'],
                  productId: cartItem['productId'],
                  quantity: cartItem['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.ordersBaseUrl}.json'),
      body: jsonEncode({
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'name': cartItem.name,
                  'price': cartItem.price,
                  'productId': cartItem.productId,
                  'quantity': cartItem.quantity,
                })
            .toList(),
        'total': cart.totalAmount,
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}

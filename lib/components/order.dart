import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({
    super.key,
    required this.order,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('R\$ ${widget.order.total}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm:ss').format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: (widget.order.products.length * 24) + 10,
              child: ListView(
                children: widget.order.products
                    .map(
                      (product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${product.quantity}x R\$${product.price}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pharma_app/components/navbar.dart';
import 'package:pharma_app/components/state.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<CartModel>(context);

    var child = <Widget>[
      const Navbar(),
    ];

    globalState.quantities
        .forEach((k, v) => child.add(MedicationItem(name: k, quantity: v)));
    return ListView(padding: const EdgeInsets.all(10), children: child);
  }
}

class MedicationItem extends StatelessWidget {
  final String name;
  final int quantity;

  const MedicationItem({required this.name, required this.quantity, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Quantity: $quantity'),
    );
  }
}

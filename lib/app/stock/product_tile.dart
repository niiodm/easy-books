import 'package:flutter/material.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/numbers.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? action;
  const ProductTile({super.key, required this.product, this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Price: ${formatNumberAsCurrency(product.price)}'),
      trailing: Chip(
        label: Text(formatNumberAsQuantity(product.quantity)),
      ),
      onTap: action,
    );
  }
}

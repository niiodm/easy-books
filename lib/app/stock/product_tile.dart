import 'package:flutter/material.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/util/numbers.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback? action;
  const ProductTile({Key? key, required this.product, this.action}) : super(key: key);

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

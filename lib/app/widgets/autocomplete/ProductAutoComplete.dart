import 'package:flutter/material.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/numbers.dart';

class ProductAutoComplete extends StatelessWidget {
  final String label;
  final List<Product> products;
  final void Function(Product) onSelected;

  const ProductAutoComplete({
    Key? key,
    required this.products,
    required this.onSelected,
    this.label = 'Select Product',
  }) : super(key: key);

  String productQuantityPriceString(Product product) {
    final name = product.name;
    final quantity = formatNumberAsQuantity(product.quantity);
    final price = formatNumberAsCurrency(product.price);
    return '$name (Qty: $quantity, Price: $price)';
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Product>(
      optionsBuilder: (value) => products.where((product) =>
          product.name.toLowerCase().contains(value.text.toLowerCase())),
      displayStringForOption: productQuantityPriceString,
      onSelected: onSelected,
      fieldViewBuilder: (_, controller, focusNode, __) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label),
        );
      },
    );
  }
}

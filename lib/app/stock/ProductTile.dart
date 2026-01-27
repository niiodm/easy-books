import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Threshold.dart' as eb;
import 'package:easy_books/util/dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/numbers.dart';

class ProductTile extends StatelessWidget with StockHelper {
  final Product product;
  final VoidCallback? action;
  final bool canDelete;

  const ProductTile(
      {Key? key, required this.product, this.action, this.canDelete = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Price: ${formatNumberAsCurrency(product.price)}'),
      trailing: FutureBuilder<eb.Threshold?>(
        future: getThresholdByProduct(product),
        builder: (context, snapshot) {
          final threshold = snapshot.data ??
              eb.Threshold(
                quantity: 0,
                product: product,
                thresholdProductId: product.id,
              );

          return Chip(
            label: Text(
              formatNumberAsQuantity(product.quantity),
              style: TextStyle(
                color: product.quantity <= threshold.quantity
                    ? Colors.white
                    : null,
              ),
            ),
            backgroundColor: product.quantity <= threshold.quantity
                ? Colors.redAccent.shade100
                : null,
          );
        },
      ),
      leading: canDelete ? CircleAvatar(
        child: IconButton(
          onPressed: () => deleteSelectedProduct(context),
          icon: const Icon(Icons.delete),
        ),
      ) : null,
      onTap: action,
    );
  }

  void deleteSelectedProduct(BuildContext context) async {
    final response = await confirm(
        context: context,
        content: 'Are you sure you want to delete ${product.name}?',
        title: 'Delete Product');

    if (response != true) return;

    deleteProduct(product);
  }
}

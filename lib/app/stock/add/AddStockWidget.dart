import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/app/stock/add/AddGoodWidget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:easy_books/util/numbers.dart';

class AddStockWidget extends StatefulWidget {
  const AddStockWidget({Key? key}) : super(key: key);

  @override
  _AddStockWidgetState createState() => _AddStockWidgetState();
}

class _AddStockWidgetState extends State<AddStockWidget> with StockHelper {
  final List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Stock'),
      ),
      body: buildItemsCard(),
      floatingActionButton: products.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            )
          : null,
    );
  }

  Card buildItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  label: const Text('Add Item'),
                  onPressed: addProduct,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            Expanded(child: buildListView(products)),
          ],
        ),
      ),
    );
  }

  void addProduct() async {
    final Product? item = await navigateTo(const AddGoodWidget(), context);
    if (item == null) return;

    products.add(item);
    setState(() {});
  }

  Widget buildListView(List<Product> products) {
    return ListView.separated(
      itemBuilder: (_, index) {
        final product = products.elementAt(index);
        return ListTile(
          title: Text(product.name),
          trailing: Chip(
            label: Text(formatNumberAsQuantity(product.quantity)),
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: products.length,
    );
  }

  void save() {
    products.forEach(addToProductQuantity);
    LogHelper.log('Added products to stock');
    Navigator.pop(context);
  }
}

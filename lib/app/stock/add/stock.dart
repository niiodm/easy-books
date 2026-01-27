import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/helper.dart';
import 'package:easy_books/app/stock/add/good.dart';
import 'package:easy_books/app/stock/helper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:easy_books/util/numbers.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> with StockHelper {
  final List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Stock'),
      ),
      body: buildItemsCard(),
      floatingActionButton: products.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: save,
              icon: Icon(Icons.save),
              label: Text('Save'),
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
                Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  label: Text('Add Item'),
                  onPressed: addProduct,
                  icon: Icon(Icons.add_circle),
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
    final Product? item = await navigateTo(AddGood(), context);
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
      separatorBuilder: (_, __) => Divider(height: 0),
      itemCount: products.length,
    );
  }

  void save() async {
    for (final product in products) {
      await addToProductQuantity(product);
    }
    LogHelper.log('Added products to stock');
    Navigator.pop(context);
  }
}

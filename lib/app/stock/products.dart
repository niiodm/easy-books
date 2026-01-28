import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/loader.dart';
import 'package:easy_books/app/stock/add/stock.dart';
import 'package:easy_books/app/stock/helper.dart';
import 'package:easy_books/app/stock/product_tile.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({super.key});

  @override
  _StockWidgetState createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockWidget> with StockHelper {
  final StreamController<String> filterController = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search by Product Name',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (text) {
              filterController.add(text);
            },
          ),
        ),
        StreamBuilder<String>(
          stream: filterController.stream,
          builder: (context, snapshot) {
            String filter = snapshot.data ?? '';
            return Expanded(
              child: FutureBuilder<List<Product>>(
                future: getProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoaderWidget();
                  }

                  final data = snapshot.data!.where((product) => 
                      product.name.toLowerCase().contains(filter.toLowerCase()));
                  return Scaffold(
                    body: data.isNotEmpty
                        ? Scrollbar(child: buildListView(data))
                        : Center(child: Text('No stock to display')),
                    floatingActionButton: FloatingActionButton.extended(
                      onPressed: () => addStock(context),
                      icon: Icon(Icons.add),
                      label: Text('Add Stock'),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  ListView buildListView(Iterable<Product> data) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        final product = data.elementAt(index);
        return ProductTile(product: product);
      },
      separatorBuilder: (_, __) => Divider(height: 0),
      itemCount: data.length,
    );
  }

  void addStock(BuildContext context) async {
    await navigateTo(AddStock(), context);
    setState(() {});
  }
}

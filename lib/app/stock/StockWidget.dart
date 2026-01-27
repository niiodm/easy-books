import 'dart:async';

import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/stock/add/AddStockWidget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/app/stock/ProductTile.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';

class StockWidget extends StatefulWidget {
  const StockWidget({Key? key}) : super(key: key);

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
            decoration: const InputDecoration(
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
                    return const LoaderWidget();
                  }

                  final data = snapshot.data!.where((product) => product.name
                      .toLowerCase()
                      .contains(filter.toLowerCase()));
                  return Scaffold(
                    body: data.isNotEmpty
                        ? Scrollbar(child: buildListView(data))
                        : const Center(child: Text('No stock to display')),
                    floatingActionButton: UserHelper.user.isAdmin
                        ? FloatingActionButton.extended(
                            onPressed: () => addStock(context),
                            icon: const Icon(Icons.add),
                            label: const Text('Add Stock'),
                          )
                        : null,
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
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: data.length,
    );
  }

  void addStock(BuildContext context) async {
    await navigateTo(const AddStockWidget(), context);
    setState(() {});
  }
}

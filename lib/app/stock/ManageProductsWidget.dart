import 'dart:async';

import 'package:easy_books/app/auth/user_helper.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/loader_widget.dart';
import 'package:easy_books/app/stock/add/AddProduct.dart';
import 'package:easy_books/app/stock/edit/EditProductWidget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/app/stock/ProductTile.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';

class ManageProductsWidget extends StatelessWidget with StockHelper {
  final StreamController<String> filterController = StreamController<String>();

  ManageProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Create Product'),
        onPressed: () => navigateTo(const AddProduct(), context),
      ),
      body: Column(
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
                child: StreamBuilder(
                  stream: productStream(),
                  builder: (context, snapshot) {
                    return FutureBuilder<List<Product>>(
                      future: getProducts(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const LoaderWidget();
                        }

                        final products = snapshot.data!.where((product) =>
                            product.name
                                .toLowerCase()
                                .contains(filter.toLowerCase()));
                        return Scrollbar(
                          child: buildListView(products, context),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView buildListView(Iterable<Product> products, BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final product = products.elementAt(index);
        return productTile(product, context);
      },
      itemCount: products.length,
    );
  }

  Widget productTile(Product product, BuildContext context) {
    return ProductTile(
      product: product,
      canDelete: UserHelper.user.isAdmin,
      action: () => navigateTo(
        EditProductWidget(product: product),
        context,
      ),
    );
  }
}

import 'package:easy_books/app/stock/add/AddCategoryWidget.dart';
import 'package:easy_books/app/stock/edit/EditCategoryWidget.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/util/navigation.dart';

class ManageCategoriesWidget extends StatelessWidget with StockHelper {
  ManageCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Create Category'),
        onPressed: () => navigateTo(const AddCategoryWidget(), context),
      ),
      body: FutureBuilder<List<Category>>(
        future: getCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoaderWidget();
          }

          final categories = snapshot.data ?? [];
          return Scrollbar(
            child: buildListView(categories, context),
          );
        },
      ),
    );
  }

  ListView buildListView(Iterable<Category> categories, BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final category = categories.elementAt(index);
        return ListTile(
          title: Text(
            category.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: FutureBuilder<List<Product>>(
              future: getProductsByCategory(category),
              builder: (context, snapshot) {
                final count = snapshot.hasData ? snapshot.data!.length : 0;
                return Text('$count products');
              }),
          onTap: () => navigateTo(EditCategoryWidget(category: category), context),
        );
      },
      itemCount: categories.length,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/loader.dart';
import 'package:easy_books/app/stock/add/category.dart';
import 'package:easy_books/app/stock/edit/category.dart';
import 'package:easy_books/app/stock/helper.dart';
import 'package:easy_books/app/stock/category_tile.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/util/navigation.dart';

class ManageCategoriesWidget extends StatefulWidget {
  const ManageCategoriesWidget({Key? key}) : super(key: key);

  @override
  _ManageCategoriesWidgetState createState() => _ManageCategoriesWidgetState();
}

class _ManageCategoriesWidgetState extends State<ManageCategoriesWidget> with StockHelper {
  final StreamController<String> filterController = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Create Category'),
        onPressed: () => createCategory(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search by Category Name',
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
                child: FutureBuilder<List<Category>>(
                  future: getCategories(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoaderWidget();
                    }

                    final categories = snapshot.data!.where((category) =>
                        category.name
                            .toLowerCase()
                            .contains(filter.toLowerCase()));
                    return Scrollbar(
                      child: buildListView(categories, context),
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

  void createCategory(BuildContext context) async {
    await navigateTo(AddCategory(), context);
    setState(() {});
  }

  ListView buildListView(Iterable<Category> categories, BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final category = categories.elementAt(index);
        return categoryTile(category, context);
      },
      itemCount: categories.length,
    );
  }

  Widget categoryTile(Category category, BuildContext context) {
    return CategoryTile(
      category: category,
      action: () => editCategory(category, context),
    );
  }

  void editCategory(Category category, BuildContext context) async {
    await navigateTo(
      EditCategory(category: category),
      context,
    );
    setState(() {});
  }
}

import 'dart:developer';

import 'package:easy_books/app/export/export_service.dart';
import 'package:easy_books/app/loader/loader_widget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:flutter/material.dart';

import 'package:easy_books/models/Category.dart';

class ImportCSVScreen extends StatefulWidget {
  const ImportCSVScreen({super.key});

  @override
  State<ImportCSVScreen> createState() => _ImportCSVScreenState();
}

class _ImportCSVScreenState extends State<ImportCSVScreen> with StockHelper {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import CSV File'),
      ),
      body: _loading
          ? const LoaderWidget(
              extra: Text('Please Wait. Importing Products'),
            )
          : Center(
              child: TextButton(
                onPressed: _loadFile,
                child: const Text('Load File'),
              ),
            ),
    );
  }

  void _loadFile() async {
    final backupService = CSVBackupService();
    final data = await backupService.import();
    final categories = await getCategories();
    final Category firstCategory = categories.isNotEmpty ? categories.first : Category(name: 'Default');
    saveCategory(firstCategory);


    final numberOfProducts = data.products.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Import $numberOfProducts products?'),
        action: SnackBarAction(
          label: 'Yes',
          onPressed: () async {
            setState(() => _loading = true);
            try {
              for (var product in data.products) {
                await saveProduct(
                  product.copyWith(categoryID: firstCategory.id),
                );
              }

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$numberOfProducts products saved!')));
            } catch (e) {
              log('Error while saving products: ${e.toString()}');
            }

            setState(() => _loading = false);
          },
        ),
      ),
    );
  }
}

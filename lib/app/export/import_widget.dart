import 'dart:developer';

import 'package:easy_books/app/auth/user_helper.dart';
import 'package:easy_books/app/expenses/expenses_helper.dart';
import 'package:easy_books/app/export/export_service.dart';
import 'package:easy_books/app/export/record_tile.dart';
import 'package:easy_books/app/loader/loader_widget.dart';
import 'package:easy_books/app/logs/log_helper.dart';
import 'package:easy_books/app/refunds/refunds_helper.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:flutter/material.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool _loading = false;
  BackupDataModel? data;
  String loaderText = '';

  @override
  Widget build(BuildContext context) {
    final hasData = data != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Data"),
      ),
      body: Visibility(
        visible: !_loading,
        replacement: LoaderWidget(extra: Text(loaderText)),
        child: !hasData
            ? const Center(
                child: Text('Please load a file to import'),
              )
            : ListView(
                children: [
                  BackupRecordTile(
                    title: "Users",
                    number: data!.users.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveUsers,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Categories",
                    number: data!.categories.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveCategories,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Products",
                    number: data!.products.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveProducts,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Stock",
                    number: data!.stocks.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveStocks,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Receipts",
                    number: data!.receipts.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveReceipts,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Sales",
                    number: data!.sales.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveSales,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Expenses",
                    number: data!.expenses.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveExpenses,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Refunds",
                    number: data!.refunds.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveRefunds,
                    ),
                  ),
                  BackupRecordTile(
                    title: "Logs",
                    number: data!.logs.length,
                    trailing: IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: saveLogs,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: hasData ? clearData : loadFile,
        label: Text(hasData ? 'Clear Data' : 'Load File'),
      ),
    );
  }

  void clearData() {
    setState(() => data = null);
  }

  void loadFile() async {
    final importService = BackupServiceFactory.getInstance();
    try {
      setState(() => _loading = true);
      final backup = await importService.import();
      setState(() => data = backup);
    } catch (e) {
      alert(context: context, content: 'Sorry an error occurred');
      log(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void saveUsers() async {
    setState(() => _loading = true);

    final userHelper = UserHelper();
    final users = data!.users;

    var length = users.length;
    for (var i = 0; i < users.length; i++) {
      setState(() => loaderText = 'Saving users: $i of $length');
      await userHelper.createUser(users.elementAt(i));
    }

    alert(context: context, content: 'Users saved successfully!');

    setState(() => _loading = false);
  }

  void saveCategories() async {
    setState(() => _loading = true);

    final stockHelper = StockHelper();

    var length = data!.categories.length;
    for (var i = 0; i < data!.categories.length; i++) {
      setState(() => loaderText = 'Saving categories: $i of $length');
      await stockHelper.saveCategory(data!.categories.elementAt(i));
    }

    alert(context: context, content: 'Categories saved successfully!');

    setState(() => _loading = false);
  }

  void saveProducts() async {
    setState(() => _loading = true);

    final stockHelper = StockHelper();

    var length = data!.products.length;
    for (var i = 0; i < data!.products.length; i++) {
      setState(() => loaderText = 'Saving products: $i of $length');
      await stockHelper.saveProduct(data!.products.elementAt(i));
    }

    alert(context: context, content: 'Products saved successfully!');

    setState(() => _loading = false);
  }

  void saveStocks() async {
    setState(() => _loading = true);

    final stockHelper = StockHelper();

    var length = data!.stocks.length;
    for (var i = 0; i < data!.stocks.length; i++) {
      setState(() => loaderText = 'Saving stocks: $i of $length');
      await stockHelper.restoreStock(data!.stocks.elementAt(i));
    }

    alert(context: context, content: 'Stocks saved successfully!');

    setState(() => _loading = false);
  }

  void saveReceipts() async {
    setState(() => _loading = true);

    final salesHelper = SalesHelper();

    var length = data!.receipts.length;
    for (var i = 0; i < data!.receipts.length; i++) {
      setState(() => loaderText = 'Saving receipts: $i of $length');
      await salesHelper.saveReceipt(data!.receipts.elementAt(i));
    }

    alert(context: context, content: 'Receipts saved successfully!');

    setState(() => _loading = false);
  }

  void saveSales() async {
    setState(() => _loading = true);

    final salesHelper = SalesHelper();

    var length = data!.sales.length;
    for (var i = 0; i < data!.sales.length; i++) {
      setState(() => loaderText = 'Saving sales: $i of $length');
      final sale = data!.sales.elementAt(i);
      // log('sale imported: ${sale.toJson()}');
      // Sale already has productId, no need to copyWith
      try {
        await salesHelper.saveSale(sale);
      } catch (e) {
        log(e.toString());
        final saleString = sale.toString();
        alert(context: context, content: saleString, title: 'Error!');
        return;
      }
    }

    alert(context: context, content: 'Sales saved successfully!');

    setState(() => _loading = false);
  }

  void saveExpenses() async {
    setState(() => _loading = true);

    final expensesHelper = ExpensesHelper();

    var length = data!.expenses.length;
    for (var i = 0; i < data!.expenses.length; i++) {
      setState(() => loaderText = 'Saving expenses: $i of $length');
      await expensesHelper.save(data!.expenses.elementAt(i));
    }

    alert(context: context, content: 'Expenses saved successfully!');

    setState(() => _loading = false);
  }

  void saveLogs() async {
    setState(() => _loading = true);

    final logHelper = LogHelper();

    var length = data!.logs.length;
    for (var i = 0; i < data!.logs.length; i++) {
      setState(() => loaderText = 'Saving logs: $i of $length');
      await logHelper.restore(data!.logs.elementAt(i));
    }

    alert(context: context, content: 'Logs saved successfully!');

    setState(() => _loading = false);
  }

  void saveRefunds() async {
    setState(() => _loading = true);

    final refundsHelper = RefundsHelper();

    var length = data!.refunds.length;
    for (var i = 0; i < data!.refunds.length; i++) {
      setState(() => loaderText = 'Saving refunds: $i of $length');
      await refundsHelper.saveRefund(data!.refunds.elementAt(i));
    }

    alert(context: context, content: 'Refunds saved successfully!');

    setState(() => _loading = false);
  }
}

import 'dart:developer';

import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/app/expenses/ExpensesHelper.dart';
import 'package:easy_books/app/export/export_service.dart';
import 'package:easy_books/app/export/record_tile.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/app/refunds/RefundsHelper.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  Future<Map<String, int>>? fetchRecords;
  BackupDataModel? data;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    fetchRecords = getRecordQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Export Data"),
      ),
      body: Visibility(
        visible: !loading,
        replacement: const LoaderWidget(),
        child: FutureBuilder<Map<String, int>>(
          future: fetchRecords,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoaderWidget();
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                String title = snapshot.data!.keys.elementAt(index);
                int number = snapshot.data![title]!;
                return BackupRecordTile(
                  title: title,
                  number: number,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: exportData,
        label: const Text('Export'),
      ),
    );
  }

  Future<Map<String, int>> getRecordQuantities() async {
    final stockHelper = StockHelper();
    final expensesHelper = ExpensesHelper();
    final logHelper = LogHelper();
    final salesHelper = SalesHelper();
    final refundsHelper = RefundsHelper();
    final userHelper = UserHelper();

    final categories = await stockHelper.getCategories();
    final expenses = await expensesHelper.getExpenses();
    final logs = await logHelper.getLogs();
    final products = await stockHelper.getProducts();
    final receipts = await salesHelper.getReceipts();
    final refunds = await refundsHelper.getRefunds();
    final sales = await salesHelper.getSales();
    final stocks = await stockHelper.getStocks();
    final users = await userHelper.findUsers();

    data = BackupDataModel(
      categories,
      expenses,
      logs,
      products,
      receipts,
      refunds,
      sales,
      stocks,
      users,
    );

    return {
      'Categories': categories.length,
      'Expenses': expenses.length,
      'Logs': logs.length,
      'Products': products.length,
      'Receipts': receipts.length,
      'Refunds': refunds.length,
      'Sales': sales.length,
      'Stocks': stocks.length,
      'Users': users.length,
    };
  }

  void exportData() async {
    setState(() => loading = true);

    final exportService = BackupServiceFactory.getInstance();
    try {
      await exportService.export(data!);

      alert(
        context: context,
        content: 'Data has been exported successfully!',
      );
    } catch (e) {
      alert(
        context: context,
        content: 'Sorry an error occurred'
            '\n${e.toString()}',
      );
      log(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }
}

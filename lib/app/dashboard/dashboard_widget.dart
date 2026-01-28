import 'package:easy_books/app/refunds/refunds_helper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/auth/user_helper.dart';
import 'package:easy_books/app/expenses/expenses_helper.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: constants.PADDING);
  final titleStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
  late DateTimeRange dateRange;

  late final salesStream = SalesHelper().observeSales().asBroadcastStream();
  late final expensesStream = ExpensesHelper().observeExpenses().asBroadcastStream();
  late final stockStream = StockHelper().productStream().asBroadcastStream();
  late final categoryStream = StockHelper().categoryStream().asBroadcastStream();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: now,
      end: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text(
                  'Report Period',
                  // style: titleStyle,
                ),
                subtitle: Text(
                  '${formatDate(dateRange.start)} '
                  'to ${formatDate(dateRange.end)}',
                ),
                trailing: TextButton.icon(
                  onPressed: selectDate,
                  icon: const Icon(Icons.date_range),
                  label: const Text('Select Date'),
                ),
              ),
            ),
            if (UserHelper.user.isAdmin)
              Card(
                child: Container(
                  padding: padding,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Stock Value',
                          style: titleStyle,
                        ),
                      ),
                      ListTile(
                        title: const Text('All Products'),
                        trailing: StreamBuilder(
                          stream: stockStream,
                          builder: (context, snapshot) {
                            return Chip(
                              label: buildSum(sumStockValues()),
                            );
                          },
                        ),
                      ),
                      StreamBuilder<List<Category>>(
                        stream: categoryStream,
                        builder: (context, snapshot) {
                          return buildCategoryStockSums();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Card(
              child: Container(
                width: double.infinity,
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                        title: Text(
                      'Summary',
                      style: titleStyle,
                    )),
                    ListTile(
                      title: const Text('Total Sales'),
                      trailing: StreamBuilder(
                        stream: salesStream,
                        builder: (context, snapshot) {
                          return Chip(
                            label: buildSum(getSaleTotals()),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Total Refunds'),
                      trailing: StreamBuilder<List<Refund>>(
                        stream: RefundsHelper()
                            .observeRefundsInDateRange(dateRange),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Chip(label: Text('GHS 0.00'));
                          }
                          final refunds = snapshot.data ?? [];
                          final refundsHelper = RefundsHelper();
                          final sum = refundsHelper.sumRefunds(refunds);
                          return Chip(
                            label: Text('GHS ${formatNumberAsCurrency(sum)}'),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Total Expenses'),
                      trailing: StreamBuilder(
                        stream: expensesStream,
                        builder: (context, snapshot) {
                          return Chip(
                            label: buildSum(getExpenseTotals()),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 0),
                    ListTile(
                      title: const Text('Balance'),
                      trailing: StreamBuilder<List<Receipt>>(
                        stream: salesStream,
                        builder: (context, salesSnapshot) {
                          return StreamBuilder<List<Expense>>(
                            stream: expensesStream,
                            builder: (context, expensesSnapshot) {
                              return StreamBuilder<List<Refund>>(
                                stream: RefundsHelper()
                                    .observeRefundsInDateRange(dateRange),
                                builder: (context, refundsSnapshot) {
                                  if (!salesSnapshot.hasData || 
                                      !expensesSnapshot.hasData || 
                                      !refundsSnapshot.hasData) {
                                    return const Chip(label: Text('GHS 0.00'));
                                  }
                                  
                                  return FutureBuilder<double>(
                                    future: _calculateBalance(
                                      salesSnapshot.data!,
                                      expensesSnapshot.data!,
                                      refundsSnapshot.data!,
                                    ),
                                    builder: (context, balanceSnapshot) {
                                      final balance = balanceSnapshot.hasData 
                                          ? balanceSnapshot.data! 
                                          : 0.0;
                                      return Chip(
                                        label: Text('GHS ${formatNumberAsCurrency(balance)}'),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: padding,
                width: double.infinity,
                child: StreamBuilder(
                  stream: salesStream,
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Sales by Category',
                            style: titleStyle,
                          ),
                        ),
                        StreamBuilder<List<Category>>(
                          stream: categoryStream,
                          builder: (context, snapshot) {
                            return buildCategorySumList();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<Map<String, Object>>> buildCategorySumList() {
    return FutureBuilder<List<Map<String, Object>>>(
      future: sumSalesByCategory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return Column(
          children: snapshot.data!
              .map(
                (e) => ListTile(
                  title: Text(e['name'] as String),
                  trailing: Chip(
                    label: Text(
                      'GHS ${formatNumberAsCurrency(e['sum'] as double)}',
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  FutureBuilder<List<Map<String, Object>>> buildCategoryStockSums() {
    return FutureBuilder<List<Map<String, Object>>>(
      future: sumStockByCategory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return Column(
          children: snapshot.data!
              .map(
                (e) => ListTile(
                  title: Text(e['name'] as String),
                  trailing: Chip(
                    label: Text(
                      'GHS ${formatNumberAsCurrency(e['sum'] as double)}',
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }

  FutureBuilder<double> buildSum(Future<double> future) {
    return FutureBuilder<double>(
      future: future,
      builder: (context, snapshot) {
        final sum = snapshot.hasData ? snapshot.data! : 0.0;
        return Text('GHS ${formatNumberAsCurrency(sum)}');
      },
    );
  }

  Future<double> getSaleTotals() async {
    final helper = SalesHelper();
    try {
      final sales = await helper.getSalesByDateRange(
        dateRange.start,
        dateRange.end,
      );
      return helper.sumSales(sales);
    } catch (e) {
      print('Error getting sum of sales: $e');
    }

    return 0.0;
  }

  Future<double> getRefundTotals() async {
    final helper = RefundsHelper();
    try {
      final refunds = await helper.getRefundsByDateRange(dateRange);
      return helper.sumRefunds(refunds);
    } catch (e) {
      print('Error getting sum of refunds: $e');
    }

    return 0.0;
  }

  Future<double> getExpenseTotals() async {
    final helper = ExpensesHelper();
    try {
      final expenses = await helper.getExpensesByDateRange(
        dateRange.start,
        dateRange.end,
      );
      return helper.sumExpenses(expenses);
    } catch (e) {
      print('Error getting sum of expenses: $e');
    }

    return 0.0;
  }

  Future<double> _calculateBalance(
    List<Receipt> allReceipts,
    List<Expense> allExpenses,
    List<Refund> refunds,
  ) async {
    final saleHelper = SalesHelper();
    final expenseHelper = ExpensesHelper();
    final refundsHelper = RefundsHelper();
    
    try {
      // Filter receipts by date range
      final nextDay = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day + 1);
      final filteredReceipts = allReceipts.where((receipt) {
        if (receipt.time == null) return false;
        return receipt.time!.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
               receipt.time!.isBefore(nextDay);
      }).toList();
      
      // Get all sales for filtered receipts
      final allSales = <Sale>[];
      for (final receipt in filteredReceipts) {
        final sales = await saleHelper.getSalesByReceipt(receipt);
        allSales.addAll(sales);
      }
      
      // Filter expenses by date range
      final filteredExpenses = allExpenses.where((expense) {
        return expense.time.isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
               expense.time.isBefore(nextDay);
      }).toList();
      
      // Calculate balance: Sales - Expenses - Refunds
      final salesTotal = saleHelper.sumSales(allSales);
      final expensesTotal = expenseHelper.sumExpenses(filteredExpenses);
      final refundsTotal = refundsHelper.sumRefunds(refunds);
      
      return salesTotal - expensesTotal - refundsTotal;
    } catch (e) {
      print('Error calculating balance: $e');
      return 0.0;
    }
  }

  Future<double> getBalance() async {
    final expenseHelper = ExpensesHelper();
    final refundsHelper = RefundsHelper();
    final saleHelper = SalesHelper();
    try {
      final expenses = await expenseHelper.getExpensesByDateRange(
        dateRange.start,
        dateRange.end,
      );
      final sales = await saleHelper.getSalesByDateRange(
        dateRange.start,
        dateRange.end,
      );
      final refunds = await refundsHelper.getRefundsByDateRange(dateRange);

      return saleHelper.sumSales(sales) -
          (expenseHelper.sumExpenses(expenses) +
              refundsHelper.sumRefunds(refunds));
    } catch (e) {
      print('Error getting balance: $e');
    }

    return 0.0;
  }

  Future<List<Map<String, Object>>> sumSalesByCategory() async {
    final stockHelper = StockHelper();
    final salesHelper = SalesHelper();

    try {
      final sales = await salesHelper.getSalesByDateRange(
        dateRange.start,
        dateRange.end,
      );

      final categories = await stockHelper.getCategories();
      final products = await stockHelper.getProducts();
      return categories.map((e) {
        final productIDs =
            products.where((p) => p.categoryID == e.id).map((e) => e.id);
        final filter = sales
            .where((sale) => productIDs.contains(sale.productId))
            .map((e) => e.quantity * e.price);
        final sum = filter.isEmpty
            ? 0.0
            : filter.reduce((value, element) => value + element);
        return {'name': e.name, 'sum': sum};
      }).toList();
    } catch (e) {
      print('Error getting sum of sales by category: $e');
    }

    return [];
  }

  Future<List<Map<String, Object>>> sumStockByCategory() async {
    final stockHelper = StockHelper();

    try {
      final categories = await stockHelper.getCategories();
      final products = await stockHelper.getProducts();
      return categories.map((e) {
        final filteredProducts =
            products.where((element) => element.categoryID == e.id);

        if (filteredProducts.isEmpty) return {'name': e.name, 'sum': 0.0};

        final sum = filteredProducts
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => element + value);
        return {'name': e.name, 'sum': sum};
      }).toList();
    } catch (e) {
      print('Error getting sum of sales by category: $e');
    }

    return [];
  }

  Future<double> sumStockValues() async {
    final stockHelper = StockHelper();
    try {
      final products = await stockHelper.getProducts();
      return stockHelper.sumProductValues(products);
    } catch (e) {
      print('Error getting sum of products: $e');
    }

    return 0;
  }
}

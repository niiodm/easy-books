import 'package:flutter/material.dart';
import 'package:serkohob/app/auth/helper.dart';
import 'package:serkohob/app/expenses/helper.dart';
import 'package:serkohob/app/sales/helper.dart';
import 'package:serkohob/app/stock/helper.dart';
import 'package:serkohob/constants.dart' as constants;
import 'package:serkohob/repositories/product_repository.dart';
import 'package:serkohob/util/numbers.dart';
import 'package:serkohob/util/temporal.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: constants.PADDING);
  final titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
  late DateTimeRange dateRange;

  final salesStream = SalesHelper().stream();
  final expensesStream = ExpensesHelper().stream();
  final stockStream = StockHelper().productStream();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: DateTime(now.year, now.month),
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
                title: Text(
                  'Report Period',
                  // style: titleStyle,
                ),
                subtitle: Text(
                  '${formatDate(dateRange.start)} '
                  'to ${formatDate(dateRange.end)}',
                ),
                trailing: TextButton.icon(
                  onPressed: selectDate,
                  icon: Icon(Icons.date_range),
                  label: Text('Select Date'),
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
                      title: Text('Sales'),
                      trailing: StreamBuilder(
                        stream: salesStream,
                        builder: (context, snapshot) {
                          return Chip(
                            label: buildSum(getSaleTotals()),
                          );
                        }
                      ),
                    ),
                    Divider(height: 0),
                    ListTile(
                      title: Text('Expenses'),
                      trailing: StreamBuilder(
                        stream: expensesStream,
                        builder: (context, snapshot) {
                          return Chip(
                            label: buildSum(getExpenseTotals()),
                          );
                        }
                      ),
                    ),
                    Divider(height: 0),
                    ListTile(
                      title: Text('Balance'),
                      trailing: StreamBuilder(
                        stream: expensesStream,
                        builder: (context, snapshot) {
                          return StreamBuilder(
                            stream: salesStream,
                            builder: (context, snapshot) {
                              return Chip(
                                label: buildSum(getBalance()),
                              );
                            }
                          );
                        }
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
                        buildCategorySumList(),
                      ],
                    );
                  }
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
                        title: Text('All Products'),
                        trailing: StreamBuilder(
                          stream: stockStream,
                          builder: (context, snapshot) {
                            return Chip(
                              label: buildSum(sumStockValues()),
                            );
                          }
                        ),
                      ),
                    ],
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
        if (!snapshot.hasData) return SizedBox();
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

  Future<double> getBalance() async {
    final expenseHelper = ExpensesHelper();
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
      return saleHelper.sumSales(sales) - expenseHelper.sumExpenses(expenses);
    } catch (e) {
      print('Error getting sum of expenses: $e');
    }

    return 0.0;
  }

  Future<List<Map<String, Object>>> sumSalesByCategory() async {
    final stockHelper = StockHelper();
    final salesHelper = SalesHelper();
    final productRepository = ProductRepository();

    try {
      final sales = await salesHelper.getSalesByDateRange(
        dateRange.start,
        dateRange.end,
      );

      // Load all products
      final productMap = <int, int?>{}; // productId -> categoryID
      for (final sale in sales) {
        if (!productMap.containsKey(sale.productId)) {
          final product = await productRepository.getProductById(sale.productId);
          if (product != null) {
            productMap[sale.productId] = product.categoryID;
          }
        }
      }

      final categories = await stockHelper.getCategories();
      return categories.map((e) {
        final filter = sales
            .where((sale) => productMap[sale.productId] == e.id)
            .map((sale) => sale.quantity * sale.price);
        final sum = filter.isEmpty
            ? 0.0
            : filter.reduce((value, element) => value + element);
        return {'name': e.name, 'sum': sum};
      }).toList();
    } catch (e) {
      print('Error getting sum of expenses: $e');
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

import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';
import 'package:flutter/material.dart';

class DailySalesReportWidget extends StatelessWidget with SalesHelper {
  DailySalesReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Sale>>(
      future: getSales(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget();
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No sales data'));
        }

        final sales = snapshot.data!;
        final dateSalesMap = <DateTime, List<Sale>>{};
        for (var sale in sales) {
          final date = DateTime(sale.time.year, sale.time.month, sale.time.day);
          if (!dateSalesMap.containsKey(date)) {
            dateSalesMap[date] = <Sale>[];
          }

          dateSalesMap[date]!.add(sale);
        }

        final dates = dateSalesMap.keys.toList()..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          itemCount: dates.length,
          itemBuilder: (_, index) {
            final date = dates[index];

            final sum = sumSales(dateSalesMap[date]!);
            return ListTile(
              subtitle: Text(formatDate(date)),
              title: Text(
                'Sum: GHS ${formatNumberAsCurrency(sum)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}

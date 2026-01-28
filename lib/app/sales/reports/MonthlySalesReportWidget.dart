import 'package:easy_books/app/loader/loader_widget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';
import 'package:flutter/material.dart';

class MonthlySalesReportWidget extends StatelessWidget with SalesHelper {
  MonthlySalesReportWidget({super.key});

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
          final monthSalesMap = <TemporalMonth, List<Sale>>{};
          for (var sale in sales) {
            final month = TemporalMonth(sale.time);
            if (!monthSalesMap.containsKey(month)) {
              monthSalesMap[month] = <Sale>[];
            }

            monthSalesMap[month]!.add(sale);
          }

          final months = monthSalesMap.keys.toList()..sort((a, b) {
            if (a.year != b.year) return b.year.compareTo(a.year);
            return b.month.compareTo(a.month);
          });

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (_, index) {
              final month = months[index];

              final sum = sumSales(monthSalesMap[month]!);
              return ListTile(
                subtitle: Text(formatMonth(month)),
                title: Text(
                  'Sum: GHS ${formatNumberAsCurrency(sum)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        });
  }
}

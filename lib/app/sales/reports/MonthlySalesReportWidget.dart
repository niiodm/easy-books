import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';
import 'package:flutter/material.dart';

class MonthlySalesReportWidget extends StatelessWidget with SalesHelper {
  const MonthlySalesReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Sale>>(
        stream: observeSales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoaderWidget();
          }

          final sales = snapshot.data!.items;
          final monthSalesMap = <TemporalMonth, List<Sale>>{};
          for (var sale in sales) {
            final month = TemporalMonth(sale.time.getDateTimeInUtc());
            if (!monthSalesMap.containsKey(month)) {
              monthSalesMap[month] = <Sale>[];
            }

            monthSalesMap[month]!.add(sale);
          }

          final months = monthSalesMap.keys;

          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (_, index) {
              final month = months.elementAt(index);

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

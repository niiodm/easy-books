import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/ModelProvider.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';
import 'package:flutter/material.dart';

class DailySalesReportWidget extends StatelessWidget with SalesHelper {
  const DailySalesReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Sale>>(
      stream: observeSales(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderWidget();
        }

        final sales = snapshot.data!.items;
        final dateSalesMap = <TemporalDate, List<Sale>>{};
        for (var sale in sales) {
          final time = TemporalDate(sale.time.getDateTimeInUtc());
          if (!dateSalesMap.containsKey(time)) {
            dateSalesMap[time] = <Sale>[];
          }

          dateSalesMap[time]!.add(sale);
        }

        final times = dateSalesMap.keys;

        return ListView.builder(
          itemCount: times.length,
          itemBuilder: (_, index) {
            final time = times.elementAt(index);

            final sum = sumSales(dateSalesMap[time]!);
            return ListTile(
              subtitle: Text(formatDate(TemporalDateTime(time.getDateTime()))),
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

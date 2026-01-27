import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:easy_books/app/refunds/add/AddRefundWidget.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/refunds/RefundsHelper.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';

class RefundsWidget extends StatefulWidget {
  const RefundsWidget({Key? key}) : super(key: key);

  @override
  _RefundsWidgetState createState() => _RefundsWidgetState();
}

class _RefundsWidgetState extends State<RefundsWidget> with RefundsHelper {
  var dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Refund>>(
      stream: observeRefundsInDateRange(dateRange),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot error: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final sum = sumRefunds(snapshot.data!.items);
        return Scaffold(
          body: Column(
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Total: GHS ${formatNumberAsCurrency(sum)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${formatDate(TemporalDateTime(dateRange.start))} '
                    'to ${formatDate(TemporalDateTime(dateRange.end))}',
                  ),
                  trailing: TextButton.icon(
                    onPressed: selectDate,
                    icon: const Icon(Icons.date_range),
                    label: const Text('Select Date'),
                  ),
                ),
              ),
              Expanded(
                child: snapshot.data!.items.isNotEmpty
                    ? Card(child: buildListView(snapshot.data!.items))
                    : const Center(child: Text('No refunds to display')),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(
              Icons.add,
            ),
            label: const Text('New Refund'),
            onPressed: () => newRefund(),
          ),
        );
      },
    );
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }

  ListView buildListView(List<Refund> data) {
    final stockHelper = StockHelper();

    return ListView.separated(
      itemBuilder: (ctx, index) {
        final refund = data.elementAt(index);

        final refundCost = refund.quantity * refund.price;
        final titleText = 'GHS ${formatNumberAsCurrency(refund.price)}'
            ' x '
            '${formatNumberAsQuantity(refund.quantity)}'
            ' = '
            'GHS ${formatNumberAsCurrency(refundCost)}';
        return ListTile(
          title: Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: FutureBuilder<Product?>(
            future: stockHelper.getProductByID(refund.refundProductId),
            builder: (context, snapshot) {
              final productName = snapshot.hasData ? snapshot.data?.name : '';

              return Text(
                'Product: $productName, '
                'Time: ${formatDateTime(refund.time)}',
              );
            },
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: data.length,
    );
  }

  void newRefund() {
    navigateTo(const AddRefundWidget(), context);
  }
}

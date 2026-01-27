import 'package:easy_books/models/Sale.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/sales/add/AddReceiptWidget.dart';
import 'package:easy_books/app/sales/details/SaleDetailsWidget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({Key? key}) : super(key: key);

  @override
  _SalesWidgetState createState() => _SalesWidgetState();
}

class _SalesWidgetState extends State<SalesWidget> with SalesHelper {
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream(),
      builder: (context, snapshot) {
        return FutureBuilder<List<Receipt>>(
          future: getReceiptsByDateRange(dateRange.start, dateRange.end),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoaderWidget();
            }

            return Scaffold(
              body: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: FutureBuilder<double>(
                        future: sumReceipts(snapshot.data!),
                        builder: (context, snapshot) {
                          final sum = snapshot.hasData ? snapshot.data! : 0.0;
                          return Text(
                            'Total: GHS ${formatNumberAsCurrency(sum)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            // style: titleStyle,
                          );
                        }
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
                  Expanded(
                    child: snapshot.data!.isNotEmpty
                        ? Card(
                            child: Scrollbar(
                              child: buildListView(snapshot.data!),
                            ),
                          )
                        : const Center(child: Text('No sales to display')),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: const Icon(Icons.add),
                label: const Text('New Sale'),
                onPressed: () => newSale(context),
              ),
            );
          },
        );
      },
    );
  }

  Future<double> sumReceipts(List<Receipt> receipts) async {
    final sales = <Sale>[];
    for (var receipt in receipts) {
      final rSales = await getSalesByReceipt(receipt);
      sales.addAll(rSales);
    }

    return sumSales(sales);
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }

  ListView buildListView(List<Receipt> data) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        final receipt = data.elementAt(index);

        return FutureBuilder<List<Sale>>(
          future: getSalesByReceipt(receipt),
          builder: (context, snapshot) {
            final sum = snapshot.hasData && snapshot.data!.isNotEmpty
                ? snapshot.data!
                    .map((sale) => sale.price * sale.quantity)
                    .reduce((acc, item) => acc + item)
                : 0.0;
            final time = receipt.time != null ? formatDateTime(receipt.time!) : 'N/A';
            final customer =
                receipt.customer != null && receipt.customer!.isNotEmpty
                    ? receipt.customer
                    : 'N/A';
            return ListTile(
              title: Text(
                'GHS ${formatNumberAsCurrency(sum)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Time: $time, To: $customer'),
              trailing: IconButton(
                onPressed: () => showDetails(receipt, context),
                icon: const Icon(Icons.info_outline),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemCount: data.length,
    );
  }

  void showDetails(Receipt receipt, BuildContext context) {
    navigateTo(SaleDetailsWidget(receipt: receipt), context);
  }

  void newSale(BuildContext context) {
    navigateTo(const AddReceiptWidget(), context);
  }
}

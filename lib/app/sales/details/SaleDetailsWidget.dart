import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/loader_widget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/util/numbers.dart';

class SaleDetailsWidget extends StatelessWidget with SalesHelper {
  final Receipt receipt;
  final padding = const EdgeInsets.all(4);

  SaleDetailsWidget({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final customer = receipt.customer != null && receipt.customer!.isNotEmpty
        ? receipt.customer!
        : 'N/A';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: ListTile(
                    title: Text(
                      customer,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text('Customer name'),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Sale>>(
                    future: getSalesByReceipt(receipt),
                    builder: (context, snapshot) {
                      final sum = snapshot.hasData
                          ? snapshot.data!
                              .map((sale) => sale.price * sale.quantity)
                              .reduce((acc, item) => acc + item)
                          : 0.0;
                      return Card(
                        child: ListTile(
                          title: Text(
                            'GHS ${formatNumberAsCurrency(sum)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text('Sale Amount'),
                        ),
                      );
                    }),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Sale>>(
              future: getSalesByReceipt(receipt),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? buildListView(snapshot.data!)
                    : const LoaderWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListView(List<Sale> data) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        final sale = data.elementAt(i);
        final amount = sale.quantity * sale.price;
        final subtitle = '${formatNumberAsQuantity(sale.quantity)}'
            ' x '
            '${formatNumberAsCurrency(sale.price)}'
            ' = '
            'GHS ${formatNumberAsCurrency(amount)}';

        final stockHelper = StockHelper();
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.shopping_cart_outlined),
            ),
            title: FutureBuilder<Product?>(
                future: stockHelper.getProductByID(sale.productId),
                builder: (context, snapshot) {
                  final productName =
                      snapshot.hasData ? snapshot.data?.name : '';
                  return Text(
                    productName ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
            subtitle: Text(subtitle),
          ),
        );
      },
      itemCount: data.length,
    );
  }
}

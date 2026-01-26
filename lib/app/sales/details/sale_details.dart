import 'package:flutter/material.dart';
import 'package:serkohob/app/loader/loader.dart';
import 'package:serkohob/app/sales/helper.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/models/Receipt.dart';
import 'package:serkohob/models/Sale.dart';
import 'package:serkohob/repositories/product_repository.dart';
import 'package:serkohob/util/numbers.dart';

class SaleDetailsWidget extends StatelessWidget with SalesHelper {
  final Receipt receipt;
  final padding = const EdgeInsets.all(4);
  final ProductRepository _productRepository = ProductRepository();

  SaleDetailsWidget({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customer =
    receipt.customer != null && receipt.customer!.isNotEmpty
        ? receipt.customer!
        : 'N/A';
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
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
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Customer name'),
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Sale Amount'),
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
                    : LoaderWidget();
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
        return FutureBuilder<Product?>(
          future: _productRepository.getProductById(sale.productId),
          builder: (context, productSnapshot) {
            final productName = productSnapshot.hasData 
                ? productSnapshot.data!.name 
                : 'Unknown';
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                title: Text(productName),
                subtitle: Text(subtitle),
              ),
            );
          },
        );
      },
      itemCount: data.length,
    );
  }
}

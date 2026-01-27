import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/app/refunds/RefundsHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/app/widgets/autocomplete/ProductAutoComplete.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:flutter/material.dart';

class AddRefundWidget extends StatefulWidget {
  const AddRefundWidget({Key? key}) : super(key: key);

  @override
  _AddRefundWidgetState createState() => _AddRefundWidgetState();
}

class _AddRefundWidgetState extends State<AddRefundWidget> with RefundsHelper {
  final _quantity = TextEditingController();
  Product? product;

  final _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Refund'),
      ),
      body: Padding(
        padding: _padding,
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: _padding,
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Column buildForm() {
    final stockHelper = StockHelper();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Product>>(
          future: stockHelper.getProducts(),
          builder: (context, snapshot) {
            final products = snapshot.hasData ? snapshot.data! : <Product>[];

            return ProductAutoComplete(
              products: products,
              onSelected: (selected) {
                setState(() => product = selected);
              },
            );
          },
        ),
        TextFormField(
          controller: _quantity,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity',
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => save(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void save(BuildContext context) async {
    final quantity = double.tryParse(_quantity.text) ?? 0.0;

    final refund = Refund(
      time: TemporalDateTime.now(),
      quantity: quantity,
      price: product!.price,
      product: product!,
      refundProductId: product!.id,
    );

    final confirmed = await confirm(
      context: context,
      title: 'Save Refund',
      content: 'Please confirm that the data is correct',
    );

    if (confirmed != true) return;

    await saveRefund(refund);
    adjustProductQuantityWithRefund(refund);

    LogHelper.log(
      'Recorded refund: '
      'product: ${product!.name}, '
      'quantity: $quantity}',
    );

    Navigator.pop(context, refund);
  }
}

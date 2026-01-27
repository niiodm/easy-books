import 'package:flutter/material.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/app/widgets/autocomplete/ProductAutoComplete.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/util/dialog.dart';

class AddSaleWidget extends StatefulWidget {
  const AddSaleWidget({Key? key}) : super(key: key);

  @override
  _AddSaleWidgetState createState() => _AddSaleWidgetState();
}

class _AddSaleWidgetState extends State<AddSaleWidget> with SalesHelper {
  final _quantity = TextEditingController();
  Product? product;

  final _formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale'),
      ),
      body: Padding(
        padding: _padding,
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: _padding,
              child: buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    final stockHelper = StockHelper();
    return Form(
      key: _formKey,
      child: Column(
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
            onPressed: () => submitForm(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    final quantity = double.tryParse(_quantity.text) ?? 0.0;

    final sale = Sale(
      productId: product!.id,
      price: product!.price,
      quantity: quantity,
      time: DateTime.now(),
    );

    if (!validateSale(sale, product!)) {
      await alert(
        context: context,
        title: 'Error',
        content: 'Invalid data. '
            '\nQuantity($quantity)'
            '\nProduct(${product?.name})',
      );
      return;
    }

    Navigator.pop(context, sale);
  }
}

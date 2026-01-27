import 'package:flutter/material.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/app/widgets/autocomplete/ProductAutoComplete.dart';
import 'package:easy_books/models/ModelProvider.dart';
import 'package:easy_books/util/dialog.dart';

class AddGoodWidget extends StatefulWidget {
  const AddGoodWidget({Key? key}) : super(key: key);

  @override
  _AddGoodWidgetState createState() => _AddGoodWidgetState();
}

class _AddGoodWidgetState extends State<AddGoodWidget> with StockHelper {
  final _quantity = TextEditingController();
  Product? product;

  final _formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
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
              return buildProductAutocomplete(products);
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

  Widget buildProductAutocomplete(List<Product> products) {
    return ProductAutoComplete(
      products: products,
      onSelected: (selected) => setState(() => product = selected),
    );
  }

  void submitForm(BuildContext context) async {
    final quantity = double.tryParse(_quantity.text) ?? 0.0;

    final item = product!.copyWith(quantity: quantity);

    if (!validateProduct(item)) {
      await alert(
        context: context,
        title: 'Error',
        content: 'Invalid data. '
            '\nQuantity($quantity)'
            '\nName(${product?.name})',
      );
      return;
    }

    Navigator.pop(context, item);
  }
}

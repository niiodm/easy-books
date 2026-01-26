import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:serkohob/app/sales/helper.dart';
import 'package:serkohob/app/stock/helper.dart';
import 'package:serkohob/app/widgets/autocomplete/select_products.dart';
import 'package:serkohob/models/ModelProvider.dart';
import 'package:serkohob/util/dialog.dart';

class AddSaleWidget extends StatefulWidget {
  const AddSaleWidget({Key? key}) : super(key: key);

  @override
  _AddSaleWidgetState createState() => _AddSaleWidgetState();
}

class _AddSaleWidgetState extends State<AddSaleWidget> with SalesHelper {
  final _quantity = TextEditingController();
  Product? product;

  final _formKey = GlobalKey<FormState>();
  final _padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sale'),
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
                  setState(() => this.product = selected);
                },
              );
            },
          ),
          TextFormField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () => submitForm(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    final quantity = double.tryParse(_quantity.text) ?? 0.0;

    final sale = Sale(
      product: product!,
      price: product!.price,
      quantity: quantity,
      time: TemporalDateTime(DateTime.now()),
    );

    if (!validateSale(sale)) {
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

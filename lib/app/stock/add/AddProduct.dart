import 'package:easy_books/models/Threshold.dart' as eb;
import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with StockHelper {
  final name = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  final threshold = TextEditingController();
  Category? category;

  final formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
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
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Product Name',
            ),
          ),
          FutureBuilder<List<Category>>(
            future: getCategories(),
            builder: (context, snapshot) {
              final categories =
                  snapshot.hasData ? snapshot.data! : <Category>[];
              return SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<Category>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  isExpanded: true,
                  value: category,
                  onChanged: (selection) {
                    setState(() => category = selection);
                  },
                  items: categories
                      .map((category) => DropdownMenuItem<Category>(
                          child: Text(category.name), value: category))
                      .toList(),
                ),
              );
            },
          ),
          TextFormField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
          ),
          TextFormField(
            controller: threshold,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Alert Threshold (Optional)',
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => submitForm(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    if (category == null) {
      alert(
        context: context,
        title: 'Error',
        content: 'Please select a product category',
      );
      return;
    }

    if (name.text.trim().isEmpty) {
      alert(
        context: context,
        title: 'Error',
        content: 'Please enter a product name',
      );
      return;
    }

    final product = Product(
      name: name.text,
      price: double.tryParse(price.text) ?? 0,
      quantity: double.tryParse(quantity.text) ?? 0,
      categoryID: category!.id,
    );

    await saveProduct(product);

    final threshold = eb.Threshold(
      quantity: double.tryParse(this.threshold.text) ?? 0,
      productId: product.id,
    );

    await saveThreshold(threshold);

    LogHelper.log(
      'Created a new product: ${product.name}, '
      'Qty: ${product.quantity}, '
      'Price: ${product.price}, '
      'Threshold: ${threshold.quantity}',
    );
    navigatePop(context);
  }
}

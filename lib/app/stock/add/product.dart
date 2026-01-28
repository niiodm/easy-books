import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/helper.dart';
import 'package:easy_books/app/stock/helper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> with StockHelper {
  final name = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  Category? category;

  final formKey = GlobalKey<FormState>();
  final _padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Form'),
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
            decoration: InputDecoration(
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
                  decoration: InputDecoration(labelText: 'Category'),
                  isExpanded: true,
                  value: category,
                  onChanged: (selection) {
                    setState(() => category = selection);
                  },
                  items: categories
                      .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name)))
                      .toList(),
                ),
              );
            },
          ),
          TextFormField(
            controller: quantity,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          TextFormField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Price',
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () => submitForm(context),
            child: Text('Save'),
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
    LogHelper.log(
      'Created a new product: ${product.name}, '
      'Qty: ${product.quantity}, '
      'Price: ${product.price}',
    );
    navigatePop(context);
  }
}

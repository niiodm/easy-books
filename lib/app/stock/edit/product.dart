import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/helper.dart';
import 'package:easy_books/app/stock/helper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class EditProduct extends StatefulWidget {
  final Product product;

  const EditProduct({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with StockHelper {
  final name = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  int? categoryID;

  final formKey = GlobalKey<FormState>();
  final _padding = EdgeInsets.all(16.0);

  @override
  void initState() {
    super.initState();

    this.name.text = widget.product.name;
    this.quantity.text = widget.product.quantity.toString();
    this.price.text = widget.product.price.toString();
    this.categoryID = widget.product.categoryID;
  }

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
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Category'),
                  isExpanded: true,
                  value: categoryID,
                  onChanged: (selection) {
                    setState(() => categoryID = selection);
                  },
                  items: categories
                      .map((category) => DropdownMenuItem<int>(
                          child: Text(category.name), value: category.id))
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
    if (categoryID == null) {
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

    final product = widget.product.copyWith(
      id: widget.product.id,
      name: name.text,
      price: double.tryParse(price.text) ?? 0,
      quantity: double.tryParse(quantity.text) ?? 0,
      categoryID: categoryID,
    );

    await saveProduct(product);
    LogHelper.log(
      'Edited product: ${widget.product.name} '
      'Qty: ${widget.product.quantity}, '
      'Price: ${widget.product.price}. '
      'To : ${product.name}, '
      'Qty: ${product.quantity}, '
      'Price: ${product.price}',
    );
    navigatePop(context);
  }
}

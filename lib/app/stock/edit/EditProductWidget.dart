import 'package:easy_books/models/Threshold.dart' as eb;
import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/log_helper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class EditProductWidget extends StatefulWidget {
  final Product product;

  const EditProductWidget({super.key, required this.product});

  @override
  _EditProductWidgetState createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> with StockHelper {
  final name = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  final threshold = TextEditingController();
  int? categoryID;

  final formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  void initState() {
    super.initState();

    name.text = widget.product.name;
    quantity.text = widget.product.quantity.toString();
    price.text = widget.product.price.toString();
    categoryID = widget.product.categoryID;
    setThreshold();
  }

  void setThreshold() async {
    final productThreshold = await getThresholdByProduct(widget.product) ??
        eb.Threshold(
          quantity: double.tryParse(threshold.text.trim()) ?? 0,
          productId: widget.product.id,
        );

    threshold.text = productThreshold.quantity.toString();
  }

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
                child: DropdownButtonFormField<int?>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  isExpanded: true,
                  value: categoryID,
                  onChanged: (selection) {
                    setState(() => categoryID = selection);
                  },
                  items: categories
                      .map((category) => DropdownMenuItem<int?>(
                          value: category.id,
                          child: Text(category.name)))
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

    final productThreshold = await getThresholdByProduct(widget.product) ??
        eb.Threshold(
          quantity: double.tryParse(threshold.text.trim()) ?? 0,
          productId: widget.product.id,
        );

    final product = widget.product.copyWith(
      name: name.text,
      price: double.tryParse(price.text) ?? 0,
      quantity: double.tryParse(quantity.text) ?? 0,
      categoryID: categoryID,
    );

    await saveProduct(product);
    await saveThreshold(
      productThreshold.copyWith(
        quantity: double.tryParse(threshold.text.trim()) ?? 0,
        productId: product.id,
      ),
    );
    LogHelper.log(
      'Edited product: ${widget.product.name}, '
      'Qty: ${widget.product.quantity}, '
      'Price: ${widget.product.price}. '
      'To : ${product.name}, '
      'Qty: ${product.quantity}, '
      'Price: ${product.price}, '
      'Threshold: ${productThreshold.quantity}',
    );
    navigatePop(context);
  }
}

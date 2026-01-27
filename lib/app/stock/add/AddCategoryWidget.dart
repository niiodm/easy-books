import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({Key? key}) : super(key: key);

  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> with StockHelper {
  final name = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Form'),
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
              labelText: 'Category Name',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => submitForm(context),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    if (name.text.trim().isEmpty) {
      alert(
        context: context,
        title: 'Error',
        content: 'Please enter a category name',
      );
      return;
    }

    final category = Category(
      name: name.text.trim(),
    );

    await saveCategory(category);
    LogHelper.log(
      'Created a new category: ${category.name}'
    );
    navigatePop(context);
  }
}

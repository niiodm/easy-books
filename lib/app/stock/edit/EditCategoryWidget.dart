import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/log_helper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class EditCategoryWidget extends StatefulWidget {
  final Category category;

  const EditCategoryWidget({super.key, required this.category});

  @override
  _EditCategoryWidgetState createState() => _EditCategoryWidgetState();
}

class _EditCategoryWidgetState extends State<EditCategoryWidget> with StockHelper {
  final name = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _padding = const EdgeInsets.all(16.0);

  @override
  void initState() {
    super.initState();

    name.text = widget.category.name;
  }

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

    final category = widget.category.copyWith(
      id: widget.category.id,
      name: name.text,
    );

    await saveCategory(category);
    LogHelper.log(
      'Edited category: ${widget.category.name} '
      'To: ${category.name}, '
    );
    navigatePop(context);
  }
}

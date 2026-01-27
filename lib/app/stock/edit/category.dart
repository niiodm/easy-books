import 'package:flutter/material.dart';
import 'package:serkohob/app/logs/helper.dart';
import 'package:serkohob/app/stock/helper.dart';
import 'package:serkohob/models/Category.dart';
import 'package:serkohob/util/dialog.dart';
import 'package:serkohob/util/navigation.dart';

class EditCategory extends StatefulWidget {
  final Category category;

  const EditCategory({Key? key, required this.category}) : super(key: key);

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> with StockHelper {
  final name = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _padding = EdgeInsets.all(16.0);

  @override
  void initState() {
    super.initState();
    this.name.text = widget.category.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Form'),
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
              labelText: 'Category Name',
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
    if (name.text.trim().isEmpty) {
      alert(
        context: context,
        title: 'Error',
        content: 'Please enter a category name',
      );
      return;
    }

    final category = widget.category.copyWith(
      name: name.text.trim(),
    );

    await saveCategory(category);
    LogHelper.log(
      'Edited category: ${widget.category.name} to ${category.name}',
    );
    navigatePop(context);
  }
}

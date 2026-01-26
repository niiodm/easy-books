import 'package:flutter/material.dart';
import 'package:serkohob/app/expenses/helper.dart';
import 'package:serkohob/app/logs/helper.dart';
import 'package:serkohob/models/Expense.dart';
import 'package:serkohob/util/dialog.dart';
import 'package:serkohob/util/numbers.dart';

class AddExpenseWidget extends StatelessWidget with ExpensesHelper {
  AddExpenseWidget({Key? key}) : super(key: key);

  final _amount = TextEditingController();
  final _description = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _padding = EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Expense'),
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
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _description,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            minLines: 1,
          ),
          TextButton(
            onPressed: () => submitForm(context),
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    final amount = double.tryParse(_amount.text) ?? 0.0;
    final description = _description.text.trim();

    final expense = Expense(
      description: description,
      amount: amount,
      time: DateTime.now(),
    );
    if (!validate(expense)) {
      await alert(
        context: context,
        title: 'Error',
        content: 'Invalid data. '
            '\nAmount($amount), '
            '\nDescription($description)',
      );
      return;
    }

    await save(expense);
    LogHelper.log('Recorded and expense of ${formatNumberAsCurrency(amount)}');
    await alert(
      context: context,
      title: 'Success',
      content: 'Expense record saved',
    );

    Navigator.pop(context, expense);
  }
}

import 'package:flutter/material.dart';
import 'package:easy_books/app/expenses/add/expense.dart';
import 'package:easy_books/app/expenses/helper.dart';
import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:easy_books/util/numbers.dart';
import 'package:easy_books/util/temporal.dart';

class ExpensesWidget extends StatefulWidget {
  const ExpensesWidget({Key? key}) : super(key: key);

  @override
  _ExpensesWidgetState createState() => _ExpensesWidgetState();
}

class _ExpensesWidgetState extends State<ExpensesWidget> with ExpensesHelper {
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream(),
      builder: (context, snapshot) {
        return FutureBuilder<List<Expense>>(
          future: getExpensesByDateRange(dateRange.start, dateRange.end),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final sum = sumExpenses(snapshot.data!);
            return Scaffold(
              body: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        'Total: GHS ${formatNumberAsCurrency(sum)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${formatDate(dateRange.start)} '
                        'to ${formatDate(dateRange.end)}',
                      ),
                      trailing: TextButton.icon(
                        onPressed: selectDate,
                        icon: Icon(Icons.date_range),
                        label: Text('Select Date'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: snapshot.data!.isNotEmpty
                        ? Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Scrollbar(
                                child: buildListView(snapshot.data!),
                              ),
                            ),
                          )
                        : Center(child: Text('No expenses to display')),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text('New Expense'),
                onPressed: () => newExpense(context),
              ),
            );
          },
        );
      },
    );
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }

  ListView buildListView(List<Expense> data) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        final reversed = data.reversed;
        final expense = reversed.elementAt(index);
        return buildListTile(expense);
      },
      separatorBuilder: (_, __) => Divider(height: 0),
      itemCount: data.length,
    );
  }

  ListTile buildListTile(Expense expense) {
    return ListTile(
      title: Text(
        expense.description,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(formatDateTime(expense.time)),
      trailing: Chip(
        label: Text('GHS ${formatNumberAsCurrency(expense.amount)}'),
      ),
    );
  }

  void newExpense(BuildContext context) {
    navigateTo(AddExpenseWidget(), context);
  }
}

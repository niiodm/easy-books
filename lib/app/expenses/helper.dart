import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:serkohob/models/Expense.dart';

class ExpensesHelper {
  Future<List<Expense>> getExpenses() {
    return Amplify.DataStore.query(Expense.classType);
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final nextDate = TemporalDate(
      DateTime(date.year, date.month, date.day + 1),
    );
    return Amplify.DataStore.query(
      Expense.classType,
      where: Expense.TIME
          .ge(TemporalDate(day).format())
          .and(Expense.TIME.lt(nextDate.format())),
      sortBy: [Expense.TIME.descending()],
    );
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) {
    final day = DateTime(start.year, start.month, start.day);
    final nextDate = TemporalDate(DateTime(end.year, end.month, end.day + 1));
    return Amplify.DataStore.query(
      Expense.classType,
      where: Expense.TIME
          .ge(TemporalDate(day).format())
          .and(Expense.TIME.lt(nextDate.format())),
      sortBy: [Expense.TIME.descending()],
    );
  }

  double sumExpenses(List<Expense> expenses) {
    return expenses.isEmpty
        ? 0
        : expenses
            .map((e) => e.amount)
            .reduce((value, element) => value + element);
  }

  bool validate(Expense expense) {
    return expense.amount > 0 && expense.description.trim().isNotEmpty;
  }

  Future<void> save(Expense expense) {
    return Amplify.DataStore.save(expense);
  }

  Stream stream() {
    return Amplify.DataStore.observe(Expense.classType);
  }
}

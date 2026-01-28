import 'package:isar/isar.dart';
import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/services/database_service.dart';

class ExpenseRepository {
  Stream<List<Expense>>? _expensesStream;

  Future<List<Expense>> getExpenses() async {
    final isar = await DatabaseService.instance;
    return await isar.expenses.where().findAll();
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final isar = await DatabaseService.instance;
    final day = DateTime(date.year, date.month, date.day);
    final nextDay = DateTime(date.year, date.month, date.day + 1);
    return await isar.expenses
        .filter()
        .timeGreaterThan(day, include: true)
        .and()
        .timeLessThan(nextDay)
        .sortByTimeDesc()
        .findAll();
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    final isar = await DatabaseService.instance;
    final day = DateTime(start.year, start.month, start.day);
    final nextDay = DateTime(end.year, end.month, end.day + 1);
    return await isar.expenses
        .filter()
        .timeGreaterThan(day, include: true)
        .and()
        .timeLessThan(nextDay)
        .sortByTimeDesc()
        .findAll();
  }

  double sumExpenses(List<Expense> expenses) {
    return expenses.isEmpty
        ? 0.0
        : expenses
            .map((e) => e.amount)
            .reduce((value, element) => value + element);
  }

  Future<void> save(Expense expense) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.expenses.put(expense);
    });
  }

  Stream<List<Expense>> watchExpenses() {
    _expensesStream ??= Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.expenses
            .where()
            .sortByTimeDesc()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    return _expensesStream!;
  }
}

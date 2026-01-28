import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/repositories/expense_repository.dart';

class ExpensesHelper {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  Future<List<Expense>> getExpenses() {
    return _expenseRepository.getExpenses();
  }

  Stream<List<Expense>> observeExpenses() {
    return _expenseRepository.watchExpenses();
  }

  Future<List<Expense>> getExpensesByDate(DateTime date) {
    return _expenseRepository.getExpensesByDate(date);
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenseRepository.getExpensesByDateRange(start, end);
  }

  double sumExpenses(List<Expense> expenses) {
    return _expenseRepository.sumExpenses(expenses);
  }

  bool validate(Expense expense) {
    return expense.amount > 0 && expense.description.trim().isNotEmpty;
  }

  Future<void> save(Expense expense) {
    return _expenseRepository.save(expense);
  }

  Stream<List<Expense>> stream() {
    return _expenseRepository.watchExpenses();
  }
}

import 'package:isar/isar.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/services/database_service.dart';

class SaleRepository {
  Stream<List<Receipt>>? _receiptsStream;

  Future<List<Receipt>> getReceipts() async {
    final isar = await DatabaseService.instance;
    final receipts = await isar.receipts
        .where()
        .sortByTimeDesc()
        .findAll();
    return receipts;
  }

  Future<List<Receipt>> getReceiptsByDateRange(DateTime start, DateTime end) async {
    final isar = await DatabaseService.instance;
    final nextDay = DateTime(end.year, end.month, end.day + 1);
    final receipts = await isar.receipts
        .filter()
        .timeGreaterThan(start, include: true)
        .and()
        .timeLessThan(nextDay)
        .sortByTimeDesc()
        .findAll();
    return receipts;
  }

  Future<List<Sale>> getSalesByDate(DateTime date) async {
    final isar = await DatabaseService.instance;
    final day = DateTime(date.year, date.month, date.day);
    final nextDay = DateTime(date.year, date.month, date.day + 1);
    final sales = await isar.sales
        .filter()
        .timeGreaterThan(day, include: true)
        .and()
        .timeLessThan(nextDay)
        .findAll();
    return await _loadProductsForSales(sales);
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final isar = await DatabaseService.instance;
    final day = DateTime(start.year, start.month, start.day);
    final nextDay = DateTime(end.year, end.month, end.day + 1);
    final sales = await isar.sales
        .filter()
        .timeGreaterThan(day, include: true)
        .and()
        .timeLessThan(nextDay)
        .findAll();
    return await _loadProductsForSales(sales);
  }

  Future<List<Sale>> getSalesByReceipt(int receiptID) async {
    final isar = await DatabaseService.instance;
    final sales = await isar.sales
        .filter()
        .receiptIDEqualTo(receiptID)
        .findAll();
    return await _loadProductsForSales(sales);
  }

  Future<List<Sale>> _loadProductsForSales(List<Sale> sales) async {
    // Products are loaded separately since we use foreign keys
    // This method maintains compatibility with existing code that expects Sale.product
    return sales;
  }

  double sumSales(List<Sale> sales) {
    return sales.isEmpty
        ? 0.0
        : sales
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => value + element);
  }

  Future<void> saveSale(Sale sale) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.sales.put(sale);
    });
  }

  Future<void> saveReceipt(Receipt receipt) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.receipts.put(receipt);
    });
  }

  Stream<List<Receipt>> watchReceipts() {
    _receiptsStream ??= Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.receipts
            .where()
            .sortByTimeDesc()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    return _receiptsStream!;
  }
}

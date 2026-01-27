import 'package:isar/isar.dart';
import 'package:easy_books/models/Stock.dart';
import 'package:easy_books/services/database_service.dart';

class StockRepository {
  Future<List<Stock>> getStocks() async {
    final isar = await DatabaseService.instance;
    return await isar.stocks.where().findAll();
  }

  Future<List<Stock>> getStocksByProductName(String productName) async {
    final isar = await DatabaseService.instance;
    return await isar.stocks
        .filter()
        .productNameEqualTo(productName)
        .findAll();
  }

  Future<Stock?> getStockById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.stocks.get(id);
  }

  Future<void> save(Stock stock) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.stocks.put(stock);
    });
  }

  Future<void> delete(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.stocks.delete(id);
    });
  }
}

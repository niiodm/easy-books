import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Sale.dart';

class SalesHelper {
  Future<List<Receipt>> getReceipts() {
    return Amplify.DataStore.query(Receipt.classType,
        sortBy: [Receipt.TIME.descending()]);
  }

  Future<List<Receipt>> getReceiptsByDateRange(DateTime start, DateTime end) {
    final nextDay = DateTime(end.year, end.month, end.day + 1);
    return Amplify.DataStore.query(Receipt.classType,
        where: Receipt.TIME
            .ge(TemporalDate(start).format())
            .and(Receipt.TIME.lt(TemporalDate(nextDay).format())),
        sortBy: [Receipt.TIME.descending()]);
  }

  Stream<QuerySnapshot<Sale>> observeSales() {
    return Amplify.DataStore.observeQuery(
      Sale.classType,
      sortBy: [Sale.TIME.descending()],
    );
  }

  Future<List<Sale>> getSales() {
    return Amplify.DataStore.query(Sale.classType);
  }

  Future<List<Sale>> getSalesByDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    final nextDate = TemporalDate(
      DateTime(date.year, date.month, date.day + 1),
    );
    return Amplify.DataStore.query(
      Sale.classType,
      where: Sale.TIME
          .ge(TemporalDate(day).format())
          .and(Sale.TIME.lt(nextDate.format())),
    );
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) {
    final day = DateTime(start.year, start.month, start.day);
    final nextDate = TemporalDate(
      DateTime(end.year, end.month, end.day + 1),
    );
    return Amplify.DataStore.query(
      Sale.classType,
      where: Sale.TIME
          .ge(TemporalDate(day).format())
          .and(Sale.TIME.lt(nextDate.format())),
    );
  }

  double sumSales(List<Sale> sales) {
    return sales.isEmpty
        ? 0.0
        : sales
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => value + element);
  }

  Future<List<Sale>> getSalesByReceipt(Receipt receipt) {
    return Amplify.DataStore.query(
      Sale.classType,
      where: Sale.RECEIPTID.eq(receipt.id),
    );
  }

  Stream<SubscriptionEvent<Receipt>> stream() {
    return Amplify.DataStore.observe(Receipt.classType);
  }

  bool validateSale(Sale sale) {
    return sale.quantity > 0 &&
        sale.price > 0 &&
        sale.product.quantity >= sale.quantity;
  }

  bool validateReceipt(Receipt receipt) {
    return receipt.sales?.isNotEmpty ?? false;
  }

  Future<void> saveSale(Sale sale) {
    return Amplify.DataStore.save(sale);
  }

  Future<void> saveReceipt(Receipt receipt) {
    return Amplify.DataStore.save(receipt);
  }

  void adjustProductQuantitiesWithSales(List<Sale> sales) {
    for (var sale in sales) {
      final product = sale.product
          .copyWith(quantity: sale.product.quantity - sale.quantity);
      Amplify.DataStore.save(product);
      final stockHelper = StockHelper();
      stockHelper.updateStock(product, product.quantity);
    }
  }
}

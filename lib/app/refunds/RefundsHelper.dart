import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/ModelProvider.dart';
import 'package:flutter/material.dart';

class RefundsHelper {
  Future<List<Refund>> getRefunds() {
    return Amplify.DataStore.query(
      Refund.classType,
      sortBy: [Refund.TIME.descending()],
    );
  }

  Future<List<Refund>> getRefundsByDateRange(DateTimeRange range) {
    final nextDay = DateTime(
      range.end.year,
      range.end.month,
      range.end.day + 1,
    );
    return Amplify.DataStore.query(
      Refund.classType,
      where: Refund.TIME
          .ge(TemporalDate(range.start).format())
          .and(Refund.TIME.lt(TemporalDate(nextDay).format())),
      sortBy: [Refund.TIME.descending()],
    );
  }

  Stream<QuerySnapshot<Refund>> observeRefundsInDateRange(DateTimeRange range) {
    final nextDay = DateTime(
      range.end.year,
      range.end.month,
      range.end.day + 1,
    );
    return Amplify.DataStore.observeQuery(
      Refund.classType,
      where: Refund.TIME
          .ge(TemporalDate(range.start).format())
          .and(Refund.TIME.lt(TemporalDate(nextDay).format())),
      sortBy: [Refund.TIME.descending()],
    );
  }

  Future<void> saveRefund(Refund refund) {
    return Amplify.DataStore.save(refund);
  }

  void adjustProductQuantityWithRefund(Refund refund) {
    final product = refund.product
        .copyWith(quantity: refund.product.quantity + refund.quantity);
    Amplify.DataStore.save(product);
    final stockHelper = StockHelper();
    stockHelper.updateStock(product, product.quantity);
  }

  double sumRefunds(List<Refund> refunds) {
    return refunds.isEmpty
        ? 0
        : refunds
            .map((e) => e.quantity * e.price)
            .reduce((value, element) => value + element);
  }
}

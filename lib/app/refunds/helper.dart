import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:serkohob/models/Refund.dart';

class RefundsHelper {
  Future<List> getRefunds() {
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

  Stream stream() {
    return Amplify.DataStore.observe(Refund.classType);
  }
}

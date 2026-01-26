import 'package:flutter/material.dart';
import 'package:serkohob/models/Refund.dart';
import 'package:serkohob/repositories/refund_repository.dart';

class RefundsHelper {
  final RefundRepository _refundRepository = RefundRepository();

  Future<List<Refund>> getRefunds() {
    return _refundRepository.getRefunds();
  }

  Future<List<Refund>> getRefundsByDateRange(DateTimeRange range) {
    return _refundRepository.getRefundsByDateRange(range.start, range.end);
  }

  Stream<List<Refund>> stream() {
    return _refundRepository.watchRefunds();
  }
}

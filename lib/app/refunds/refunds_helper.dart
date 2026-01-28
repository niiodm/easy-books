import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/repositories/product_repository.dart';
import 'package:easy_books/repositories/refund_repository.dart';
import 'package:flutter/material.dart';

class RefundsHelper {
  final RefundRepository _refundRepository = RefundRepository();
  final ProductRepository _productRepository = ProductRepository();

  Future<List<Refund>> getRefunds() {
    return _refundRepository.getRefunds();
  }

  Future<List<Refund>> getRefundsByDateRange(DateTimeRange range) {
    return _refundRepository.getRefundsByDateRange(range.start, range.end);
  }

  Stream<List<Refund>> observeRefundsInDateRange(DateTimeRange range) {
    return _refundRepository.watchRefunds();
  }

  Future<void> saveRefund(Refund refund) {
    return _refundRepository.save(refund);
  }

  Future<void> adjustProductQuantityWithRefund(Refund refund) async {
    if (refund.productId != null) {
      final product = await _productRepository.getProductById(refund.productId!);
      if (product != null) {
        final updatedProduct = product.copyWith(
          quantity: product.quantity + refund.quantity,
        );
        await _productRepository.saveProduct(updatedProduct);
        final stockHelper = StockHelper();
        await stockHelper.updateStock(updatedProduct, updatedProduct.quantity);
      }
    }
  }

  double sumRefunds(List<Refund> refunds) {
    return refunds.isEmpty
        ? 0
        : refunds
            .map((e) => e.quantity * (e.price ?? 0))
            .reduce((value, element) => value + element);
  }
}

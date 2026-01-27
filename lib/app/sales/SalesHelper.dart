import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/repositories/product_repository.dart';
import 'package:easy_books/repositories/sale_repository.dart';

class SalesHelper {
  final SaleRepository _saleRepository = SaleRepository();
  final ProductRepository _productRepository = ProductRepository();

  Future<List<Receipt>> getReceipts() {
    return _saleRepository.getReceipts();
  }

  Future<List<Receipt>> getReceiptsByDateRange(DateTime start, DateTime end) {
    return _saleRepository.getReceiptsByDateRange(start, end);
  }

  Stream<List<Receipt>> observeSales() {
    return _saleRepository.watchReceipts();
  }

  Future<List<Sale>> getSales() async {
    final receipts = await getReceipts();
    final allSales = <Sale>[];
    for (final receipt in receipts) {
      final sales = await getSalesByReceipt(receipt);
      allSales.addAll(sales);
    }
    return allSales;
  }

  Future<List<Sale>> getSalesByDate(DateTime date) {
    return _saleRepository.getSalesByDate(date);
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) {
    return _saleRepository.getSalesByDateRange(start, end);
  }

  double sumSales(List<Sale> sales) {
    return _saleRepository.sumSales(sales);
  }

  Future<List<Sale>> getSalesByReceipt(Receipt receipt) {
    return _saleRepository.getSalesByReceipt(receipt.id);
  }

  Stream<List<Receipt>> stream() {
    return _saleRepository.watchReceipts();
  }

  bool validateSale(Sale sale, Product product) {
    return sale.quantity > 0 &&
        sale.price > 0 &&
        product.quantity >= sale.quantity;
  }

  bool validateReceipt(Receipt receipt) {
    // Receipt validation will be done when saving sales
    return true;
  }

  Future<void> saveSale(Sale sale) {
    return _saleRepository.saveSale(sale);
  }

  Future<void> saveReceipt(Receipt receipt) {
    return _saleRepository.saveReceipt(receipt);
  }

  Future<void> adjustProductQuantitiesWithSales(List<Sale> sales) async {
    final stockHelper = StockHelper();
    for (var sale in sales) {
      final product = await _productRepository.getProductById(sale.productId);
      if (product != null) {
        final updatedProduct = product.copyWith(
          quantity: product.quantity - sale.quantity,
        );
        await _productRepository.saveProduct(updatedProduct);
        await stockHelper.updateStock(updatedProduct, updatedProduct.quantity);
      }
    }
  }
}

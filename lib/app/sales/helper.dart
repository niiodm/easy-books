import 'package:serkohob/app/stock/helper.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/models/Receipt.dart';
import 'package:serkohob/models/Sale.dart';
import 'package:serkohob/repositories/product_repository.dart';
import 'package:serkohob/repositories/sale_repository.dart';

class SalesHelper {
  final SaleRepository _saleRepository = SaleRepository();
  final ProductRepository _productRepository = ProductRepository();

  Future<List<Receipt>> getReceipts() {
    return _saleRepository.getReceipts();
  }

  Future<List<Receipt>> getReceiptsByDateRange(DateTime start, DateTime end) {
    return _saleRepository.getReceiptsByDateRange(start, end);
  }

  Future<List<Sale>> getSalesByDate(DateTime date) async {
    final sales = await _saleRepository.getSalesByDate(date);
    return await _loadProductsForSales(sales);
  }

  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) async {
    final sales = await _saleRepository.getSalesByDateRange(start, end);
    return await _loadProductsForSales(sales);
  }

  double sumSales(List<Sale> sales) {
    return _saleRepository.sumSales(sales);
  }

  Future<List<Sale>> getSalesByReceipt(Receipt receipt) async {
    final sales = await _saleRepository.getSalesByReceipt(receipt.id);
    return await _loadProductsForSales(sales);
  }

  Future<List<Sale>> _loadProductsForSales(List<Sale> sales) async {
    // Load products for each sale
    final productIds = sales.map((s) => s.productId).toSet();
    final products = <int, Product>{};
    for (final productId in productIds) {
      final product = await _productRepository.getProductById(productId);
      if (product != null) {
        products[productId] = product;
      }
    }
    // Note: Sale model now uses productId, but we maintain compatibility
    // by loading products separately when needed
    return sales;
  }

  Stream<List<Receipt>> stream() {
    return _saleRepository.watchReceipts();
  }

  bool validateSale(Sale sale, Product product) {
    return sale.quantity > 0 &&
        sale.price > 0 &&
        product.quantity >= sale.quantity;
  }

  bool validateReceipt(List<Sale> sales) {
    return sales.isNotEmpty;
  }

  Future<void> saveSale(Sale sale) {
    return _saleRepository.saveSale(sale);
  }

  Future<void> saveReceipt(Receipt receipt) {
    return _saleRepository.saveReceipt(receipt);
  }

  Future<void> adjustProductQuantities(List<Sale> sales) async {
    final productRepository = ProductRepository();
    final stockHelper = StockHelper();
    
    for (final sale in sales) {
      final product = await productRepository.getProductById(sale.productId);
      if (product != null) {
        final updatedProduct = product.copyWith(
          id: product.id,
          quantity: product.quantity - sale.quantity,
        );
        await productRepository.saveProduct(updatedProduct);
        await stockHelper.updateStock(updatedProduct, updatedProduct.quantity);
      }
    }
  }
}

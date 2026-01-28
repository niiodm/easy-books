import 'package:isar/isar.dart';
import 'package:easy_books/models/Category.dart' as model;
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Stock.dart';
import 'package:easy_books/models/Threshold.dart';
import 'package:easy_books/repositories/product_repository.dart';
import 'package:easy_books/repositories/stock_repository.dart';
import 'package:easy_books/repositories/threshold_repository.dart';

class StockHelper {
  final ProductRepository _productRepository = ProductRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final StockRepository _stockRepository = StockRepository();
  final ThresholdRepository _thresholdRepository = ThresholdRepository();

  Future<List<Product>> getProducts() {
    return _productRepository.getProducts();
  }

  Future<void> deleteProduct(Product product) {
    return _productRepository.deleteProduct(product.id);
  }

  Future<List<Stock>> getStocks() {
    return _stockRepository.getStocks();
  }

  Future<void> restoreStock(Stock stock) {
    return _stockRepository.save(stock);
  }

  Future<Product?> getProductByID(Id id) async {
    return await _productRepository.getProductById(id);
  }

  Future<List<Product>> getProductsByCategory(model.Category category) {
    return _productRepository.getProductsByCategory(category.id);
  }

  Future<void> saveProduct(Product product) {
    return _productRepository.saveProduct(product);
  }

  Future<void> saveThreshold(Threshold threshold) {
    return _thresholdRepository.save(threshold);
  }

  Future<void> saveCategory(model.Category category) {
    return _categoryRepository.saveCategory(category);
  }

  Stream<List<Product>> productStream() {
    return _productRepository.watchProducts();
  }

  Stream<List<model.Category>> categoryStream() {
    return _categoryRepository.watchCategories();
  }

  Future<List<model.Category>> getCategories() {
    return _categoryRepository.getCategories();
  }

  bool validateProduct(Product product) {
    return product.name.isNotEmpty && product.price > 0 && product.quantity > 0;
  }

  Future<void> addToProductQuantity(Product product) async {
    final oldProduct = await _productRepository.getProductById(product.id);
    if (oldProduct != null) {
      final updatedProduct = oldProduct.copyWith(
        id: oldProduct.id,
        quantity: product.quantity + oldProduct.quantity,
      );
      await _productRepository.saveProduct(updatedProduct);
      await updateStock(updatedProduct, updatedProduct.quantity);
    }
  }

  Future<void> subtractFromProductQuantity(Product product) async {
    final oldProduct = await _productRepository.getProductById(product.id);
    if (oldProduct != null) {
      final updatedProduct = oldProduct.copyWith(
        id: oldProduct.id,
        quantity: oldProduct.quantity - product.quantity,
      );
      await _productRepository.saveProduct(updatedProduct);
    }
  }

  Future<void> updateStock(Product product, double quantity) async {
    final stocks = await _stockRepository.getStocksByProductName(product.name);

    if (stocks.isEmpty) {
      await _stockRepository.save(
        Stock(
          quantity: quantity,
          productName: product.name,
          date: DateTime.now(),
        ),
      );
    } else {
      final stock = stocks.first;
      await _stockRepository.save(
        stock.copyWith(id: stock.id, quantity: quantity),
      );
    }
  }

  double sumProductValues(List<Product> products) {
    return products.isEmpty
        ? 0.0
        : products
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => value + element);
  }

  Future<Threshold?> getThresholdByProduct(Product product) async {
    return await _thresholdRepository.getThresholdByProductId(product.id);
  }
}

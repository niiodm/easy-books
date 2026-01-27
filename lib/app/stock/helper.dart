import 'package:isar/isar.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Stock.dart';
import 'package:easy_books/repositories/product_repository.dart';
import 'package:easy_books/repositories/stock_repository.dart';

class StockHelper {
  final ProductRepository _productRepository = ProductRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();
  final StockRepository _stockRepository = StockRepository();

  Future<List<Product>> getProducts() {
    return _productRepository.getProducts();
  }

  Future<void> saveProduct(Product product) {
    return _productRepository.saveProduct(product);
  }

  Stream<List<Product>> productStream() {
    return _productRepository.watchProducts();
  }

  Future<List<Category>> getCategories() {
    return _categoryRepository.getCategories();
  }

  Future<void> saveCategory(Category category) {
    return _categoryRepository.saveCategory(category);
  }

  Future<void> deleteCategory(Id id) {
    return _categoryRepository.deleteCategory(id);
  }

  Future<List<Product>> getProductsByCategory(int categoryID) {
    return _productRepository.getProductsByCategory(categoryID);
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
}

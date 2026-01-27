import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/models/ModelProvider.dart';
import 'package:easy_books/models/Category.dart' as model;

class StockHelper {
  Future<List<Product>> getProducts() {
    return Amplify.DataStore.query(Product.classType,
        sortBy: [Product.NAME.ascending()]);
  }

  Future<void> deleteProduct(Product product) {
    return Amplify.DataStore.delete(product);
  }

  Future<List<Stock>> getStocks() {
    return Amplify.DataStore.query(Stock.classType);
  }

  Future<void> restoreStock(Stock stock) {
    return Amplify.DataStore.save(stock);
  }

  Future<Product?> getProductByID(String id) async {
    final products = await Amplify.DataStore.query(
      Product.classType,
      where: Product.ID.eq(id),
    );
    return products.first;
  }

  Future<List<Product>> getProductsByCategory(model.Category category) {
    return Amplify.DataStore.query(Product.classType,
        where: Product.CATEGORYID.eq(category.id),
        sortBy: [Product.NAME.ascending()]);
  }

  Future<void> saveProduct(Product product) {
    return Amplify.DataStore.save(product);
  }

  Future<void> saveThreshold(Threshold threshold) {
    return Amplify.DataStore.save(threshold);
  }

  Future<void> saveCategory(model.Category category) {
    return Amplify.DataStore.save(category);
  }

  Stream productStream() {
    return Amplify.DataStore.observeQuery(Product.classType);
  }

  Stream<QuerySnapshot<model.Category>> categoryStream() {
    return Amplify.DataStore.observeQuery(
      model.Category.classType,
      sortBy: [model.Category.NAME.ascending()],
    );
  }

  Future<List<model.Category>> getCategories() {
    return Amplify.DataStore.query(model.Category.classType,
        sortBy: [model.Category.NAME.ascending()]);
  }

  bool validateProduct(Product product) {
    return product.name.isNotEmpty && product.price > 0 && product.quantity > 0;
  }

  Future<void> addToProductQuantity(Product product) async {
    final oldProduct = (await Amplify.DataStore.query(
      Product.classType,
      where: Product.ID.eq(product.id),
    ))
        .first;
    final updatedProduct =
        oldProduct.copyWith(quantity: product.quantity + oldProduct.quantity);

    final stockHelper = StockHelper();
    stockHelper.updateStock(updatedProduct, updatedProduct.quantity);
    return Amplify.DataStore.save(updatedProduct);
  }

  Future<void> subtractFromProductQuantity(Product product) async {
    final oldProduct = (await Amplify.DataStore.query(
      Product.classType,
      where: Product.ID.eq(product.id),
    ))
        .first;
    final updatedProduct =
        oldProduct.copyWith(quantity: oldProduct.quantity - product.quantity);
    return Amplify.DataStore.save(updatedProduct);
  }

  Future<void> updateStock(Product product, double quantity) async {
    final stocks = await Amplify.DataStore.query(Stock.classType,
        where: Stock.PRODUCTNAME.eq(product.name));

    if (stocks.isEmpty) {
      return Amplify.DataStore.save(
        Stock(
          quantity: quantity,
          productName: product.name,
          date: TemporalDate.now(),
        ),
      );
    }

    final stock = stocks.first;
    return Amplify.DataStore.save(
      stock.copyWith(quantity: quantity),
    );
  }

  double sumProductValues(List<Product> products) {
    return products.isEmpty
        ? 0.0
        : products
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => value + element);
  }

  Future<Threshold?> getThresholdByProduct(Product product) async {
    final thresholds = await Amplify.DataStore.query(
      Threshold.classType,
      where: Threshold.THRESHOLDPRODUCTID.eq(product.id),
    );

    return thresholds.isNotEmpty ? thresholds.first : null;
  }
}

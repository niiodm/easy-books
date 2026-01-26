import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:serkohob/models/Category.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/models/Stock.dart';

class StockHelper {
  Future<List<Product>> getProducts() {
    return Amplify.DataStore.query(Product.classType,
        sortBy: [Product.NAME.ascending()]);
  }

  Future<void> saveProduct(Product product) {
    return Amplify.DataStore.save(product);
  }

  Stream productStream() {
    return Amplify.DataStore.observe(Product.classType);
  }

  Future<List<Category>> getCategories() {
    return Amplify.DataStore.query(Category.classType);
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
}

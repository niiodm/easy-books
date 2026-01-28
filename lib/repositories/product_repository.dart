import 'package:isar/isar.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/services/database_service.dart';

class ProductRepository {
  Stream<List<Product>>? _productsStream;

  Future<List<Product>> getProducts() async {
    final isar = await DatabaseService.instance;
    return await isar.products
        .where()
        .sortByName()
        .findAll();
  }

  Future<Product?> getProductById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.products.get(id);
  }

  Future<List<Product>> getProductsByCategory(int categoryID) async {
    final isar = await DatabaseService.instance;
    return await isar.products
        .filter()
        .categoryIDEqualTo(categoryID)
        .findAll();
  }

  Future<void> saveProduct(Product product) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.products.put(product);
    });
  }

  Future<void> deleteProduct(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.products.delete(id);
    });
  }

  Stream<List<Product>> watchProducts() {
    _productsStream ??= Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.products
            .where()
            .sortByName()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    return _productsStream!;
  }
}

class CategoryRepository {
  Future<List<Category>> getCategories() async {
    final isar = await DatabaseService.instance;
    return await isar.categorys.where().findAll();
  }

  Future<Category?> getCategoryById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.categorys.get(id);
  }

  Future<void> saveCategory(Category category) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.categorys.put(category);
    });
  }

  Future<void> deleteCategory(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.categorys.delete(id);
    });
  }
}

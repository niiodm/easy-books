import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serkohob/models/Category.dart';
import 'package:serkohob/models/Expense.dart';
import 'package:serkohob/models/Log.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/models/Receipt.dart';
import 'package:serkohob/models/Refund.dart';
import 'package:serkohob/models/Sale.dart';
import 'package:serkohob/models/Stock.dart';
import 'package:serkohob/models/User.dart';
import 'package:serkohob/models/Version.dart';

class DatabaseService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        UserSchema,
        CategorySchema,
        ProductSchema,
        SaleSchema,
        ReceiptSchema,
        ExpenseSchema,
        RefundSchema,
        StockSchema,
        LogSchema,
        VersionSchema,
      ],
      directory: dir.path,
    );

    // Seed database with default admin user if no users exist
    await _seedDatabase();

    return _isar!;
  }

  static Future<void> _seedDatabase() async {
    final users = await _isar!.users.where().findAll();
    if (users.isEmpty) {
      final adminUser = User(
        username: 'admin',
        password: 'admin',
        isAdmin: true,
      );
      await _isar!.writeTxn(() async {
        await _isar!.users.put(adminUser);
      });
    }
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_books/models/AdminData.dart';
import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/models/Log.dart';
import 'package:easy_books/models/Permissions.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/models/Stock.dart';
import 'package:easy_books/models/Threshold.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/models/Version.dart';

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
        ThresholdSchema,
        AdminDataSchema,
        PermissionsSchema,
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

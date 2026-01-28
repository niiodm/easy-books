import 'dart:convert';
import 'dart:io';

import 'package:easy_books/models/Category.dart';
import 'package:easy_books/models/Expense.dart';
import 'package:easy_books/models/Log.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Refund.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/models/Stock.dart';
import 'package:easy_books/models/User.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupDataModel {
  final List<Category> categories;
  final List<Expense> expenses;
  final List<Log> logs;
  final List<Product> products;
  final List<Receipt> receipts;
  final List<Refund> refunds;
  final List<Sale> sales;
  final List<Stock> stocks;
  final List<User> users;

  BackupDataModel(
    this.categories,
    this.expenses,
    this.logs,
    this.products,
    this.receipts,
    this.refunds,
    this.sales,
    this.stocks,
    this.users,
  );

  Map<String, List<Map<String, dynamic>>> toJson() {
    final json = <String, List<Map<String, dynamic>>>{};
    // TODO: Implement toJson for Isar models
    json['categories'] = categories.map((e) => <String, dynamic>{'id': e.id, 'name': e.name}).toList();
    json['expenses'] = expenses.map((e) => <String, dynamic>{'id': e.id, 'description': e.description, 'amount': e.amount, 'time': e.time.toIso8601String()}).toList();
    json['logs'] = logs.map((e) => <String, dynamic>{'id': e.id, 'log': e.log, 'user': e.user, 'time': e.time.toIso8601String()}).toList();
    json['products'] = products.map((e) => <String, dynamic>{'id': e.id, 'name': e.name, 'price': e.price, 'quantity': e.quantity, 'categoryID': e.categoryID}).toList();
    json['receipts'] = receipts.map((e) => <String, dynamic>{'id': e.id, 'customer': e.customer, 'time': e.time?.toIso8601String()}).toList();
    json['refunds'] = refunds.map((e) => <String, dynamic>{'id': e.id, 'quantity': e.quantity, 'price': e.price, 'productId': e.productId, 'description': e.description, 'time': e.time.toIso8601String()}).toList();
    json['sales'] = sales.map((e) => <String, dynamic>{'id': e.id, 'quantity': e.quantity, 'price': e.price, 'productId': e.productId, 'receiptID': e.receiptID, 'time': e.time.toIso8601String()}).toList();
    json['stocks'] = stocks.map((e) => <String, dynamic>{'id': e.id, 'quantity': e.quantity, 'productName': e.productName, 'date': e.date.toIso8601String()}).toList();
    json['users'] = users.map((e) => <String, dynamic>{'id': e.id, 'username': e.username, 'password': e.password, 'isAdmin': e.isAdmin}).toList();

    return json;
  }

  factory BackupDataModel.fromJson(
      Map<String, List<Map<String, dynamic>>> json) {
    // TODO: Implement fromJson for Isar models
    return BackupDataModel(
      (json['categories'] ?? []).map((e) => Category(name: e['name'] as String)).toList(),
      (json['expenses'] ?? []).map((e) => Expense(description: e['description'] as String, amount: (e['amount'] as num).toDouble(), time: DateTime.parse(e['time'] as String))).toList(),
      (json['logs'] ?? []).map((e) => Log(time: DateTime.parse(e['time'] as String), log: e['log'] as String, user: e['user'] as String)).toList(),
      (json['products'] ?? []).map((e) => Product(name: e['name'] as String, price: (e['price'] as num).toDouble(), quantity: (e['quantity'] as num).toDouble(), categoryID: e['categoryID'] as int?)).toList(),
      (json['receipts'] ?? []).map((e) => Receipt(customer: e['customer'] as String?, time: e['time'] != null ? DateTime.parse(e['time'] as String) : null)).toList(),
      (json['refunds'] ?? []).map((e) => Refund(time: DateTime.parse(e['time'] as String), quantity: (e['quantity'] as num).toDouble(), price: e['price'] != null ? (e['price'] as num).toDouble() : null, productId: e['productId'] as int?, description: e['description'] as String?)).toList(),
      (json['sales'] ?? []).map((e) => Sale(time: DateTime.parse(e['time'] as String), quantity: (e['quantity'] as num).toDouble(), price: (e['price'] as num).toDouble(), productId: e['productId'] as int, receiptID: e['receiptID'] as int?)).toList(),
      (json['stocks'] ?? []).map((e) => Stock(quantity: (e['quantity'] as num).toDouble(), productName: e['productName'] as String?, date: DateTime.parse(e['date'] as String))).toList(),
      (json['users'] ?? []).map((e) => User(username: e['username'] as String, password: e['password'] as String, isAdmin: e['isAdmin'] as bool)).toList(),
    );
  }
}

abstract class BackupService {
  Future<void> export(BackupDataModel data);

  Future<BackupDataModel> import();
}

class JsonFileBackupService extends BackupService {
  Future<String?>? saveFileDialog(String path) async {
    final params = SaveFileDialogParams(sourceFilePath: path);
    final filePath = await FlutterFileDialog.saveFile(params: params);
    return filePath;
  }

  @override
  Future<void> export(BackupDataModel data) async {
    final permissionIsGranted = await Permission.storage.request().isGranted;
    if (!permissionIsGranted) {
      throw Exception('Permission is not granted');
    }

    final directory = await getTemporaryDirectory();
    final exportFile = File('${directory.path}/easy-books-export.json');

    final asJson = json.encode(data.toJson());
    await exportFile.writeAsString(asJson);

    await saveFileDialog(exportFile.path);
    await exportFile.delete();
  }

  @override
  Future<BackupDataModel> import() async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['json']);

    if (result == null) {
      throw Exception('File not selected');
    }

    final path = result.files.single.path!;
    File file = File(path);

    final jsonText = await file.readAsString();
    final Map<String, dynamic> asJson = json.decode(jsonText);
    final Map<String, List<Map<String, dynamic>>> backupJson = {};

    for (var key in asJson.keys) {
      backupJson[key] = (asJson[key] as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return BackupDataModel.fromJson(backupJson);
  }
}

class CSVBackupService extends BackupService {
  @override
  Future<void> export(BackupDataModel data) {
    // TODO: implement export
    throw UnimplementedError();
  }

  @override
  Future<BackupDataModel> import() async {
    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['json']);

    if (result == null) {
      throw Exception('File not selected');
    }

    final path = result.files.single.path!;
    File file = File(path);

    final csvString = await file.readAsString();
    final lines = csvString.split("\n");
    final products = lines.map(_productFromLine).toList();

    return BackupDataModel([], [], [], products, [], [], [], [], []);
  }

  Product _productFromLine(String line) {
    final parts = line.split(',');
    final name = parts.first;
    final price = parts.last.trim();

    return Product(
      name: name,
      price: double.tryParse(price) ?? 0.0,
      quantity: 0.0,
    );
  }
}

class BackupServiceFactory {
  static BackupService getInstance() => JsonFileBackupService();
}

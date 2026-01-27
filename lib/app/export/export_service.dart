import 'dart:convert';
import 'dart:io';

import 'package:easy_books/models/ModelProvider.dart';
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
    json['categories'] = categories.map((e) => e.toJson()).toList();
    json['expenses'] = expenses.map((e) => e.toJson()).toList();
    json['logs'] = logs.map((e) => e.toJson()).toList();
    json['products'] = products.map((e) => e.toJson()).toList();
    json['receipts'] = receipts.map((e) => e.toJson()).toList();
    json['refunds'] = refunds.map((e) => e.toJson()).toList();
    json['sales'] = sales.map((e) => e.toJson()).toList();
    json['stocks'] = stocks.map((e) => e.toJson()).toList();
    json['users'] = users.map((e) => e.toJson()).toList();

    return json;
  }

  factory BackupDataModel.fromJson(
      Map<String, List<Map<String, dynamic>>> json) {
    return BackupDataModel(
      json['categories']?.map((e) => Category.fromJson(e)).toList() ?? [],
      json['expenses']?.map((e) => Expense.fromJson(e)).toList() ?? [],
      json['logs']?.map((e) => Log.fromJson(e)).toList() ?? [],
      json['products']?.map((e) => Product.fromJson(e)).toList() ?? [],
      json['receipts']?.map((e) => Receipt.fromJson(e)).toList() ?? [],
      json['refunds']?.map((e) => Refund.fromJson(e)).toList() ?? [],
      json['sales']?.map((e) => Sale.fromJson(e)).toList() ?? [],
      json['stocks']?.map((e) => Stock.fromJson(e)).toList() ?? [],
      json['users']?.map((e) => User.fromJson(e)).toList() ?? [],
    );
  }
}

abstract class BackupService {
  Future<void> export(BackupDataModel data);

  Future<BackupDataModel> import();
}

class JsonFileBackupService extends BackupService {
  saveFileDialog(String path) async {
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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
    FilePickerResult? result = await FilePicker.platform.pickFiles();

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

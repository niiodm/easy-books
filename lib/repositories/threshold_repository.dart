import 'package:isar/isar.dart';
import 'package:easy_books/models/Threshold.dart';
import 'package:easy_books/services/database_service.dart';

class ThresholdRepository {
  Future<List<Threshold>> getThresholds() async {
    final isar = await DatabaseService.instance;
    return await isar.thresholds.where().findAll();
  }

  Future<Threshold?> getThresholdById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.thresholds.get(id);
  }

  Future<Threshold?> getThresholdByProductId(int productId) async {
    final isar = await DatabaseService.instance;
    final thresholds = await isar.thresholds
        .filter()
        .productIdEqualTo(productId)
        .findAll();
    return thresholds.isNotEmpty ? thresholds.first : null;
  }

  Future<void> save(Threshold threshold) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.thresholds.put(threshold);
    });
  }

  Future<void> delete(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.thresholds.delete(id);
    });
  }
}

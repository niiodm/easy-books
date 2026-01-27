import 'package:isar/isar.dart';
import 'package:easy_books/models/AdminData.dart';
import 'package:easy_books/services/database_service.dart';

class AdminDataRepository {
  Future<List<AdminData>> getAll() async {
    final isar = await DatabaseService.instance;
    return await isar.adminDatas.where().findAll();
  }

  Future<AdminData?> getByKey(String key) async {
    final isar = await DatabaseService.instance;
    final adminDatas = await isar.adminDatas
        .filter()
        .keyEqualTo(key)
        .findAll();
    return adminDatas.isNotEmpty ? adminDatas.first : null;
  }

  Future<String?> getValue(String key) async {
    final adminData = await getByKey(key);
    return adminData?.value;
  }

  Future<void> save(AdminData adminData) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.adminDatas.put(adminData);
    });
  }

  Future<void> setValue(String key, String value) async {
    final existing = await getByKey(key);
    if (existing != null) {
      final updated = existing.copyWith(value: value);
      await save(updated);
    } else {
      final adminData = AdminData(key: key, value: value);
      await save(adminData);
    }
  }

  Future<void> delete(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.adminDatas.delete(id);
    });
  }

  Future<void> deleteByKey(String key) async {
    final adminData = await getByKey(key);
    if (adminData != null) {
      await delete(adminData.id);
    }
  }
}

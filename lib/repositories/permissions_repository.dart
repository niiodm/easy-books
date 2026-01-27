import 'package:isar/isar.dart';
import 'package:easy_books/models/Permissions.dart';
import 'package:easy_books/services/database_service.dart';

class PermissionsRepository {
  Future<List<Permissions>> getAllPermissions() async {
    final isar = await DatabaseService.instance;
    return await isar.permissions.where().findAll();
  }

  Future<Permissions?> getPermissionsById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.permissions.get(id);
  }

  Future<Permissions?> getPermissionsByUserId(int userId) async {
    final isar = await DatabaseService.instance;
    final permissions = await isar.permissions
        .filter()
        .userIdEqualTo(userId)
        .findAll();
    return permissions.isNotEmpty ? permissions.first : null;
  }

  Future<void> save(Permissions permissions) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.permissions.put(permissions);
    });
  }

  Future<void> delete(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.permissions.delete(id);
    });
  }
}

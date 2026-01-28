import 'package:isar/isar.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/services/database_service.dart';

class UserRepository {
  Stream<List<User>>? _usersStream;

  Future<User?> findUserByCredentials(String username, String password) async {
    final isar = await DatabaseService.instance;
    final users = await isar.users
        .filter()
        .usernameEqualTo(username)
        .and()
        .passwordEqualTo(password)
        .findAll();
    return users.isNotEmpty ? users.first : null;
  }

  Future<User?> getUserById(Id id) async {
    final isar = await DatabaseService.instance;
    return await isar.users.get(id);
  }

  Future<List<User>> getAllUsers() async {
    final isar = await DatabaseService.instance;
    return await isar.users.where().findAll();
  }

  Future<void> saveUser(User user) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  Future<void> deleteUser(Id id) async {
    final isar = await DatabaseService.instance;
    await isar.writeTxn(() async {
      await isar.users.delete(id);
    });
  }

  Stream<List<User>> watchUsers() {
    _usersStream ??= Stream.fromFuture(DatabaseService.instance).asyncExpand((isar) {
        return isar.users
            .where()
            .watch(fireImmediately: true)
            .asBroadcastStream();
      }).asBroadcastStream();
    return _usersStream!;
  }
}

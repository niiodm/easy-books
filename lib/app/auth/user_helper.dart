import 'package:easy_books/constants.dart';
import 'package:easy_books/models/AdminData.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/repositories/admin_data_repository.dart';
import 'package:easy_books/repositories/user_repository.dart';

class UserHelper {
  static late User user;

  final UserRepository _userRepository = UserRepository();
  final AdminDataRepository _adminDataRepository = AdminDataRepository();

  Future<User?> findUserByCredentials(String username, String password) async {
    return await _userRepository.findUserByCredentials(username, password);
  }

  Future<List<User>> findUsers() {
    return _userRepository.getAllUsers();
  }

  Stream<List<User>> usersStream() async* {
    final users = await _userRepository.getAllUsers();
    yield users;
    // Note: For real-time updates, we'd need to add watchUsers to UserRepository
    // For now, return a single emission
  }

  Future<void> createUser(User user) {
    return _userRepository.saveUser(user);
  }

  Future<List<AdminData>> getAdminPasswords() async {
    final adminData = await _adminDataRepository.getByKey(SUPER);
    return adminData != null ? [adminData] : [];
  }
}

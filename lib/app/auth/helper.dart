import 'package:serkohob/app/auth/auth_service.dart';
import 'package:serkohob/models/User.dart';

class UserHelper {
  static User get user {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      throw StateError('No user logged in');
    }
    return currentUser;
  }

  Future<User?> findUserByCredentials(String username, String password) async {
    final success = await AuthService.login(username, password);
    return success ? AuthService.currentUser : null;
  }
}

import 'package:serkohob/models/User.dart';
import 'package:serkohob/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _currentUserIdKey = 'current_user_id';
  static User? _currentUser;
  static final UserRepository _userRepository = UserRepository();

  static User? get currentUser => _currentUser;

  static Future<bool> login(String username, String password) async {
    final user = await _userRepository.findUserByCredentials(username, password);
    if (user != null) {
      _currentUser = user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_currentUserIdKey, user.id);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }

  static Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_currentUserIdKey);
    if (userId != null) {
      _currentUser = await _userRepository.getUserById(userId);
    }
  }

  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.isAdmin ?? false;
}

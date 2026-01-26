import 'package:amplify_flutter/amplify.dart';
import 'package:serkohob/models/User.dart';

class UserHelper {
  static late User user;

  Future<User?> findUserByCredentials(String username, String password) async {
    final results = await Amplify.DataStore.query(
      User.classType,
      where: User.USERNAME.eq(username).and(User.PASSWORD.eq(password)),
    );

    return results.isNotEmpty ? results.first : null;
  }
}

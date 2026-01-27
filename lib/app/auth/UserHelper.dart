import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/constants.dart';
import 'package:easy_books/models/AdminData.dart';
import 'package:easy_books/models/User.dart';

class UserHelper {
  static late User user;

  Future<User?> findUserByCredentials(String username, String password) async {
    final results = await Amplify.DataStore.query(
      User.classType,
      where: User.USERNAME.eq(username).and(User.PASSWORD.eq(password)),
    );

    return results.isNotEmpty ? results.first : null;
  }

  Future<List<User>> findUsers() {
    return Amplify.DataStore.query(
      User.classType,
      sortBy: [User.USERNAME.ascending()],
    );
  }

  Stream<QuerySnapshot<User>> usersStream() {
    return Amplify.DataStore.observeQuery(
      User.classType,
      sortBy: [User.USERNAME.ascending()],
    );
  }

  Future<void> createUser(User user) {
    return Amplify.DataStore.save(user);
  }

  Future<SignInResult> amplifySignIn(String phone, String password) {
    return Amplify.Auth.signIn(username: phone, password: password);
  }

  Future<SignInResult> amplifyConfirmSignIn(String password) {
    return Amplify.Auth.confirmSignIn(
      confirmationValue: password,
    );
  }

  Future<List<AdminData>> getAdminPasswords() {
    return Amplify.DataStore.query(
      AdminData.classType,
      where: AdminData.KEY.eq(SUPER),
    );
  }
}

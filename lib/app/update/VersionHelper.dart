import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/models/Version.dart';

class VersionHelper {
  static const CURRENT_VERSION = 5;

  Future<List<Version>> getVersions() {
    return Amplify.DataStore.query(
      Version.classType,
      sortBy: [Version.VERSION.descending()],
    );
  }
}

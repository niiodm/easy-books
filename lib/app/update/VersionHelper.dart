import 'package:easy_books/models/Version.dart';
import 'package:easy_books/repositories/version_repository.dart';

class VersionHelper {
  static const CURRENT_VERSION = 5;

  final VersionRepository _versionRepository = VersionRepository();

  Future<List<Version>> getVersions() {
    return _versionRepository.getVersions();
  }
}

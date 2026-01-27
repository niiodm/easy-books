import 'package:easy_books/models/Version.dart';
import 'package:easy_books/services/database_service.dart';
import 'package:isar/isar.dart';

class VersionRepository {
  Future<List<Version>> getVersions() async {
    final isar = await DatabaseService.instance;
    final versions = await isar.versions.where().anyId().findAll();
    versions.sort((a, b) => b.version.compareTo(a.version));
    return versions;
  }
}

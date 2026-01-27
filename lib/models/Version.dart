import 'package:isar/isar.dart';

part 'Version.g.dart';

@collection
class Version {
  Id id = Isar.autoIncrement;

  int version;

  String link;

  Version({
    required this.version,
    required this.link,
  });

  Version copyWith({
    Id? id,
    int? version,
    String? link,
  }) {
    final versionObj = Version(
      version: version ?? this.version,
      link: link ?? this.link,
    );
    if (id != null) {
      versionObj.id = id;
    }
    return versionObj;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Version &&
        id == other.id &&
        version == other.version &&
        link == other.link;
  }

  @override
  int get hashCode => Object.hash(id, version, link);

  @override
  String toString() {
    return 'Version {id=$id, version=$version, link=$link}';
  }
}

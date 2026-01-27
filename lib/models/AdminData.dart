import 'package:isar/isar.dart';

part 'AdminData.g.dart';

@collection
class AdminData {
  Id id = Isar.autoIncrement;

  String key;

  String value;

  AdminData({
    required this.key,
    required this.value,
  });

  AdminData copyWith({
    Id? id,
    String? key,
    String? value,
  }) {
    final adminData = AdminData(
      key: key ?? this.key,
      value: value ?? this.value,
    );
    if (id != null) {
      adminData.id = id;
    }
    return adminData;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminData &&
        id == other.id &&
        key == other.key &&
        value == other.value;
  }

  @override
  int get hashCode => Object.hash(id, key, value);

  @override
  String toString() {
    return 'AdminData {id=$id, key=$key, value=$value}';
  }
}

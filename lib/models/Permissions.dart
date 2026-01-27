import 'package:isar/isar.dart';
import 'StaffPermissions.dart';

part 'Permissions.g.dart';

@collection
class Permissions {
  Id id = Isar.autoIncrement;

  @Enumerated(EnumType.name)
  List<StaffPermissions>? permissions;

  @Index()
  int? userId;

  Permissions({
    this.permissions,
    this.userId,
  });

  Permissions copyWith({
    Id? id,
    List<StaffPermissions>? permissions,
    int? userId,
  }) {
    final permissionsObj = Permissions(
      permissions: permissions ?? this.permissions,
      userId: userId ?? this.userId,
    );
    if (id != null) {
      permissionsObj.id = id;
    }
    return permissionsObj;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Permissions &&
        id == other.id &&
        _listEquals(permissions, other.permissions) &&
        userId == other.userId;
  }

  @override
  int get hashCode => Object.hash(id, permissions, userId);

  @override
  String toString() {
    return 'Permissions {id=$id, permissions=$permissions, userId=$userId}';
  }

  bool _listEquals(List<StaffPermissions>? a, List<StaffPermissions>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

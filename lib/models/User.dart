import 'package:isar/isar.dart';

part 'User.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  String username;

  String password;

  bool isAdmin;

  User({
    required this.username,
    required this.password,
    required this.isAdmin,
  });

  User copyWith({
    Id? id,
    String? username,
    String? password,
    bool? isAdmin,
  }) {
    final user = User(
      username: username ?? this.username,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
    );
    if (id != null) {
      user.id = id;
    }
    return user;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        username == other.username &&
        password == other.password &&
        isAdmin == other.isAdmin;
  }

  @override
  int get hashCode => Object.hash(id, username, password, isAdmin);

  @override
  String toString() {
    return 'User {id=$id, username=$username, isAdmin=$isAdmin}';
  }
}

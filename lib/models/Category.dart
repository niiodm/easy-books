import 'package:isar/isar.dart';

part 'Category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  String name;

  Category({
    required this.name,
  });

  Category copyWith({
    Id? id,
    String? name,
  }) {
    final category = Category(
      name: name ?? this.name,
    );
    if (id != null) {
      category.id = id;
    }
    return category;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Category &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() {
    return 'Category {id=$id, name=$name}';
  }
}

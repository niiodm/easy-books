import 'package:isar/isar.dart';

part 'Product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;

  String name;

  double price;

  @Index()
  int? categoryID;

  double quantity;

  Product({
    required this.name,
    required this.price,
    this.categoryID,
    required this.quantity,
  });

  Product copyWith({
    Id? id,
    String? name,
    double? price,
    int? categoryID,
    double? quantity,
  }) {
    final product = Product(
      name: name ?? this.name,
      price: price ?? this.price,
      categoryID: categoryID ?? this.categoryID,
      quantity: quantity ?? this.quantity,
    );
    if (id != null) {
      product.id = id;
    }
    return product;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Product &&
        id == other.id &&
        name == other.name &&
        price == other.price &&
        categoryID == other.categoryID &&
        quantity == other.quantity;
  }

  @override
  int get hashCode => Object.hash(id, name, price, categoryID, quantity);

  @override
  String toString() {
    return 'Product {id=$id, name=$name, price=$price, categoryID=$categoryID, quantity=$quantity}';
  }
}

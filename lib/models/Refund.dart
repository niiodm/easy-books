import 'package:isar/isar.dart';

part 'Refund.g.dart';

@collection
class Refund {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime time;

  double quantity;

  double? price;

  @Index()
  int? productId;

  String? description;

  Refund({
    required this.time,
    required this.quantity,
    this.price,
    this.productId,
    this.description,
  });

  Refund copyWith({
    Id? id,
    DateTime? time,
    double? quantity,
    double? price,
    int? productId,
    String? description,
  }) {
    final refund = Refund(
      time: time ?? this.time,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productId: productId ?? this.productId,
      description: description ?? this.description,
    );
    if (id != null) {
      refund.id = id;
    }
    return refund;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Refund &&
        id == other.id &&
        time == other.time &&
        quantity == other.quantity &&
        price == other.price &&
        productId == other.productId &&
        description == other.description;
  }

  @override
  int get hashCode => Object.hash(id, time, quantity, price, productId, description);

  @override
  String toString() {
    return 'Refund {id=$id, time=$time, quantity=$quantity, price=$price, productId=$productId, description=$description}';
  }
}

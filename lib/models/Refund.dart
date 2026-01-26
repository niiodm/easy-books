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

  Refund({
    required this.time,
    required this.quantity,
    this.price,
    this.productId,
  });

  Refund copyWith({
    Id? id,
    DateTime? time,
    double? quantity,
    double? price,
    int? productId,
  }) {
    final refund = Refund(
      time: time ?? this.time,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productId: productId ?? this.productId,
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
        productId == other.productId;
  }

  @override
  int get hashCode => Object.hash(id, time, quantity, price, productId);

  @override
  String toString() {
    return 'Refund {id=$id, time=$time, quantity=$quantity, price=$price, productId=$productId}';
  }
}

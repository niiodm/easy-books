import 'package:isar/isar.dart';

part 'Threshold.g.dart';

@collection
class Threshold {
  Id id = Isar.autoIncrement;

  double quantity;

  @Index()
  int? productId;

  Threshold({
    required this.quantity,
    this.productId,
  });

  Threshold copyWith({
    Id? id,
    double? quantity,
    int? productId,
  }) {
    final threshold = Threshold(
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
    );
    if (id != null) {
      threshold.id = id;
    }
    return threshold;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Threshold &&
        id == other.id &&
        quantity == other.quantity &&
        productId == other.productId;
  }

  @override
  int get hashCode => Object.hash(id, quantity, productId);

  @override
  String toString() {
    return 'Threshold {id=$id, quantity=$quantity, productId=$productId}';
  }
}

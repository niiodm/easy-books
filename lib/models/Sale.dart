import 'package:isar/isar.dart';

part 'Sale.g.dart';

@collection
class Sale {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime time;

  double quantity;

  @Index()
  int productId;

  @Index()
  int? receiptID;

  double price;

  Sale({
    required this.time,
    required this.quantity,
    required this.productId,
    this.receiptID,
    required this.price,
  });

  Sale copyWith({
    Id? id,
    DateTime? time,
    double? quantity,
    int? productId,
    int? receiptID,
    double? price,
  }) {
    final sale = Sale(
      time: time ?? this.time,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
      receiptID: receiptID ?? this.receiptID,
      price: price ?? this.price,
    );
    if (id != null) {
      sale.id = id;
    }
    return sale;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Sale &&
        id == other.id &&
        time == other.time &&
        quantity == other.quantity &&
        productId == other.productId &&
        receiptID == other.receiptID &&
        price == other.price;
  }

  @override
  int get hashCode => Object.hash(id, time, quantity, productId, receiptID, price);

  @override
  String toString() {
    return 'Sale {id=$id, time=$time, quantity=$quantity, productId=$productId, receiptID=$receiptID, price=$price}';
  }
}

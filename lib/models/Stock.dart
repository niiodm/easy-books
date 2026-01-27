import 'package:isar/isar.dart';

part 'Stock.g.dart';

@collection
class Stock {
  Id id = Isar.autoIncrement;

  double quantity;

  String? productName;

  @Index()
  DateTime date;

  Stock({
    required this.quantity,
    this.productName,
    required this.date,
  });

  Stock copyWith({
    Id? id,
    double? quantity,
    String? productName,
    DateTime? date,
  }) {
    final stock = Stock(
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      date: date ?? this.date,
    );
    if (id != null) {
      stock.id = id;
    }
    return stock;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stock &&
        id == other.id &&
        quantity == other.quantity &&
        productName == other.productName &&
        date == other.date;
  }

  @override
  int get hashCode => Object.hash(id, quantity, productName, date);

  @override
  String toString() {
    return 'Stock {id=$id, quantity=$quantity, productName=$productName, date=$date}';
  }
}

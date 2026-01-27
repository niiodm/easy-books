import 'package:isar/isar.dart';

part 'Receipt.g.dart';

@collection
class Receipt {
  Id id = Isar.autoIncrement;

  String? customer;

  @Index()
  DateTime? time;

  Receipt({
    this.customer,
    this.time,
  });

  Receipt copyWith({
    Id? id,
    String? customer,
    DateTime? time,
  }) {
    final receipt = Receipt(
      customer: customer ?? this.customer,
      time: time ?? this.time,
    );
    if (id != null) {
      receipt.id = id;
    }
    return receipt;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Receipt &&
        id == other.id &&
        customer == other.customer &&
        time == other.time;
  }

  @override
  int get hashCode => Object.hash(id, customer, time);

  @override
  String toString() {
    return 'Receipt {id=$id, customer=$customer, time=$time}';
  }
}

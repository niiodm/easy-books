import 'package:isar/isar.dart';

part 'Expense.g.dart';

@collection
class Expense {
  Id id = Isar.autoIncrement;

  String description;

  double amount;

  @Index()
  DateTime time;

  Expense({
    required this.description,
    required this.amount,
    required this.time,
  });

  Expense copyWith({
    Id? id,
    String? description,
    double? amount,
    DateTime? time,
  }) {
    final expense = Expense(
      description: description ?? this.description,
      amount: amount ?? this.amount,
      time: time ?? this.time,
    );
    if (id != null) {
      expense.id = id;
    }
    return expense;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Expense &&
        id == other.id &&
        description == other.description &&
        amount == other.amount &&
        time == other.time;
  }

  @override
  int get hashCode => Object.hash(id, description, amount, time);

  @override
  String toString() {
    return 'Expense {id=$id, description=$description, amount=$amount, time=$time}';
  }
}

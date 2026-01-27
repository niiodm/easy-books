import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime time) {
  const format = 'MMM dd y h:mm a';
  return DateFormat(format).format(time.toLocal());
}

String formatDate(DateTime time) {
  const format = 'MMM dd, y';
  return DateFormat(format).format(time.toLocal());
}

String formatMonth(TemporalMonth time) {
  const format = 'MMM y';
  return DateFormat(format).format(time.date);
}

String formatTime(DateTime time) {
  const format = 'h:mm a';
  return DateFormat(format).format(time.toLocal());
}

Future<DateTime?> selectDate(BuildContext context, {DateTime? initialDate} ) async {
  final firstDate = DateTime(2021);
  final lastDate = DateTime(2071);
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

Future<DateTimeRange?> selectDateRange(BuildContext context, {DateTime? initialDate} ) async {
  final firstDate = DateTime(2021);
  final lastDate = DateTime(2071);
  return showDateRangePicker(
    context: context,
    currentDate: initialDate ?? DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

class TemporalMonth {
  late int year;
  late int month;
  final DateTime date;

  TemporalMonth(this.date) {
    year = date.year;
    month = date.month;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemporalMonth &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}

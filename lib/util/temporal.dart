import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime time) {
  final format = 'MMM dd y h:mm a';
  return DateFormat(format).format(time.toLocal());
}

String formatDate(DateTime time) {
  final format = 'MMM dd, y';
  return DateFormat(format).format(time.toLocal());
}

String formatTime(DateTime time) {
  final format = 'h:mm a';
  return DateFormat(format).format(time.toLocal());
}

Future<DateTime?> selectDate(BuildContext context, {DateTime? initialDate}) async {
  final firstDate = DateTime(2021);
  final lastDate = DateTime(2071);
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

Future<DateTimeRange?> selectDateRange(BuildContext context, {DateTime? initialDate}) async {
  final firstDate = DateTime(2021);
  final lastDate = DateTime(2071);
  return showDateRangePicker(
    context: context,
    currentDate: initialDate ?? DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
  );
}

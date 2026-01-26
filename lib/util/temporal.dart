import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDateTime(TemporalDateTime time) {
  final format = 'MMM dd y h:mm a';
  return DateFormat(format).format(time.getDateTimeInUtc());
}

String formatDate(TemporalDateTime time) {
  final format = 'MMM dd, y';
  return DateFormat(format).format(time.getDateTimeInUtc());
}

String formatTime(TemporalDateTime time) {
  final format = 'h:mm a';
  return DateFormat(format).format(time.getDateTimeInUtc());
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
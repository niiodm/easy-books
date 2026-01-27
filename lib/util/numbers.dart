import 'package:intl/intl.dart';

String formatNumberAsCurrency(double number) {
  const format = '#,###,##0.00';
  return NumberFormat(format).format(number);
}

String formatNumberAsQuantity(double number) {
  const format = '#,###,##0.##';
  return NumberFormat(format).format(number);
}
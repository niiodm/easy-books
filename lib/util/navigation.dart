import 'package:flutter/material.dart';

Future<dynamic> navigateTo(Widget destination, BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (x) => destination),
  );
}

Future<dynamic> navigateReplacement(Widget destination, BuildContext context) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (x) => destination),
  );
}

void navigatePop(BuildContext context, {dynamic returnValue}) {
  return Navigator.pop(context, returnValue);
}

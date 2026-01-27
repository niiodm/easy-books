import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:flutter/material.dart';

class StoreLoginWidget extends StatelessWidget {
  const StoreLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to staff login since we're using local auth
    return const StaffLoginWidget();
  }
}

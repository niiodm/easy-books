import 'package:easy_books/app/auth/staff_login_widget.dart';
import 'package:flutter/material.dart';

class StoreLoginWidget extends StatelessWidget {
  const StoreLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to staff login since we're using local auth
    return const StaffLoginWidget();
  }
}

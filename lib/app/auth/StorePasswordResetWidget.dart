import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:flutter/material.dart';

class StorePasswordResetWidget extends StatelessWidget {
  const StorePasswordResetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to staff login since we're using local auth
    // Password reset functionality can be added later if needed
    return const StaffLoginWidget();
  }
}

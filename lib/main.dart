import 'package:flutter/material.dart';
import 'package:easy_books/app/auth/staff_login_widget.dart';
import 'package:easy_books/app/auth/auth_service.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService.instance;
  
  // Restore user session if available
  await AuthService.restoreSession();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: constants.APP_NAME,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: constants.themeColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: constants.themeColor
      ),
      home: const StaffLoginWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:serkohob/app/auth/auth_service.dart';
import 'package:serkohob/app/auth/login.dart';
import 'package:serkohob/constants.dart' as constants;
import 'package:serkohob/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize database
  await DatabaseService.instance;
  // Restore session if exists
  await AuthService.restoreSession();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: LoginWidget(),
    );
  }
}

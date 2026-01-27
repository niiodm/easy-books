import 'package:flutter/material.dart';
import 'package:easy_books/app/AmplifyApp.dart';
import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:easy_books/constants.dart' as constants;

void main() {
  runApp(const AmplifyApp(
    child: MyApp(),
    localOnly: true,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      // builder: Authenticator.builder(),
      home: const StaffLoginWidget(),
    );
  }
}

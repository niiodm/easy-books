import 'package:flutter/material.dart';
import 'package:serkohob/app/amplify_app.dart';
import 'package:serkohob/app/auth/login.dart';
import 'package:serkohob/constants.dart' as constants;

void main() {
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
      home: AmplifyApp(
        child: LoginWidget(),
      ),
    );
  }
}

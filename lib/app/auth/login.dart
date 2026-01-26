import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:serkohob/app/auth/helper.dart';
import 'package:serkohob/app/home.dart';
import 'package:serkohob/app/logs/helper.dart';
import 'package:serkohob/constants.dart' as constants;
import 'package:serkohob/util/dialog.dart';
import 'package:serkohob/util/navigation.dart';

class LoginWidget extends StatelessWidget with UserHelper {
  LoginWidget({Key? key}) : super(key: key);

  final _key = GlobalKey<FormState>();
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(constants.PADDING),
          child: Card(
            child: Container(
              width: getValueForScreenType<double>(
                context: context,
                mobile: double.infinity,
                tablet: 500,
              ),
              padding: EdgeInsets.all(constants.PADDING),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'EasyBooks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Divider(),
                      TextFormField(
                        controller: username,
                        decoration: InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      TextButton(
                        onPressed: () => login(context),
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    final username = this.username.text.trim();
    final password = this.password.text.trim();

    final user = await findUserByCredentials(username, password);
    if (user != null) {
      if (!user.isAdmin) LogHelper.log('Logged in');

      navigateReplacement(HomeWidget(), context);
      return;
    }

    alert(
      context: context,
      title: 'Login Error',
      content: 'Please check the credentials and try again',
    );
  }
}

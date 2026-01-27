import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class StorePasswordResetWidget extends StatefulWidget {
  const StorePasswordResetWidget({Key? key}) : super(key: key);

  @override
  _StoreLoginWidgetState createState() => _StoreLoginWidgetState();
}

class _StoreLoginWidgetState extends State<StorePasswordResetWidget>
    with UserHelper {
  final _key = GlobalKey<FormState>();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Password Reset'),
      ),
      body: loading ? const LoaderWidget() : Center(
        child: Padding(
          padding: const EdgeInsets.all(constants.PADDING),
          child: Card(
            child: Container(
              width: getValueForScreenType<double>(
                context: context,
                mobile: double.infinity,
                tablet: 500,
              ),
              padding: const EdgeInsets.all(constants.PADDING),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      const Text('Please set a new and secure password.'),
                      const Divider(),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                        ),
                      ),
                      TextFormField(
                        controller: confirmPassword,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => login(context),
                          child: const Text('Login'),
                        ),
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
    if (confirmPassword.text.trim().isEmpty ||
        password.text.trim().isEmpty) {
      alert(
        context: context,
        content: 'Please enter passwords',
      );
      return;
    }

    if (confirmPassword.text != password.text) {
      alert(
        context: context,
        content: 'The passwords do not match',
      );
      return;
    }

    try {
      setState(() => loading = true);
      final signInResult = await amplifyConfirmSignIn(password.text);
      if (signInResult.isSignedIn) {
        navigateReplacement(const StaffLoginWidget(), context);
        return;
      }

      setState(() => loading = false);
      alert(
        context: context,
        title: 'Login Error',
        content: signInResult.nextStep!.signInStep,
      );
    } on AuthException catch (e) {
      setState(() => loading = false);
      alert(
        context: context,
        title: 'Login Error',
        content: 'Password reset error: ${e.message}',
      );
    }
  }
}

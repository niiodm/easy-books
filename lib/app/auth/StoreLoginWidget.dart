import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:easy_books/app/auth/StorePasswordResetWidget.dart';
import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class StoreLoginWidget extends StatefulWidget {
  const StoreLoginWidget({Key? key}) : super(key: key);

  @override
  _StoreLoginWidgetState createState() => _StoreLoginWidgetState();
}

class _StoreLoginWidgetState extends State<StoreLoginWidget> with UserHelper {
  final _key = GlobalKey<FormState>();
  final password = TextEditingController();
  final phone = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Sign In'),
      ),
      body: loading
          ? const LoaderWidget()
          : Center(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Phone Number'),
                            IntlPhoneField(
                              initialCountryCode: 'GH',
                              onChanged: (number) {
                                phone.text = !number.number.startsWith('0')
                                    ? number.completeNumber
                                    : number.countryCode+
                                        number.number.substring(1);
                              },
                            ),
                            TextFormField(
                              controller: password,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
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
    if (phone.text.trim().isEmpty || password.text.trim().isEmpty) {
      alert(
        context: context,
        content: 'Please enter phone number and password',
      );
      return;
    }

    try {
      setState(() => loading = true);
      final signInResult = await amplifySignIn(phone.text, password.text);
      if (signInResult.isSignedIn) {
        navigateReplacement(const StaffLoginWidget(), context);
        return;
      }

      if (signInResult.nextStep != null &&
          signInResult.nextStep!.signInStep ==
              'CONFIRM_SIGN_IN_WITH_NEW_PASSWORD') {
        navigateReplacement(const StorePasswordResetWidget(), context);
        return;
      }

      setState(() => loading = false);
      alert(
        context: context,
        title: 'Login Error',
        content: signInResult.nextStep!.signInStep,
      );
    } on AuthException {
      setState(() => loading = false);
      alert(
        context: context,
        title: 'Login Error',
        content: 'Please check the credentials and try again',
      );
    }
  }
}

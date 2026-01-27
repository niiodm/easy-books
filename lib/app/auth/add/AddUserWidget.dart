import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:flutter/material.dart';

class AddUserWidget extends StatefulWidget {
  const AddUserWidget({Key? key}) : super(key: key);

  @override
  _AddUserWidgetState createState() => _AddUserWidgetState();
}

class _AddUserWidgetState extends State<AddUserWidget> with UserHelper {
  final _padding = const EdgeInsets.all(16.0);
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool? isAdmin = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Form'),
      ),
      body: Padding(
        padding: _padding,
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: _padding,
              child: buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: username,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextFormField(
            controller: confirmPassword,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
          ),
          SwitchListTile(
            title: const Text('Is A Manager'),
            value: isAdmin!,
            onChanged: (value) {
              setState(() {
                isAdmin = value;
              });
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => submitForm(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void submitForm(BuildContext context) async {
    if (username.text.trim().isEmpty) {
      alert(
        context: context,
        title: 'Error',
        content: 'Please enter a username',
      );
      return;
    }

    if (password.text.trim() != confirmPassword.text.trim()) {
      alert(
        context: context,
        title: 'Error',
        content: 'The passwords do not match. Please try again',
      );
      return;
    }

    final user = User(
      username: username.text.trim(),
      password: password.text,
      isAdmin: isAdmin!,
    );

    await createUser(user);
    LogHelper.log(
      'Created a new staff: ${user.username}'
    );

    navigatePop(context);
  }
}

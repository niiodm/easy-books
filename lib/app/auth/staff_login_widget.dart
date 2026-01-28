import 'dart:developer';

import 'package:easy_books/util/hashing.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_books/app/auth/user_helper.dart';
import 'package:easy_books/app/auth/auth_service.dart';
import 'package:easy_books/models/User.dart';
import 'package:easy_books/app/home_widget.dart';
import 'package:easy_books/app/logs/log_helper.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class StaffLoginWidget extends StatefulWidget {
  const StaffLoginWidget({super.key});

  @override
  State<StaffLoginWidget> createState() => _StaffLoginWidgetState();
}

class _StaffLoginWidgetState extends State<StaffLoginWidget> with UserHelper {
  final _key = GlobalKey<FormState>();
  final password = TextEditingController();

  String? username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Sign In'),
        actions: [
          IconButton(
            onPressed: () {
              try {
                adminLogin();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            icon: const Icon(Icons.admin_panel_settings),
          ),
        ],
      ),
      body: Center(
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
                      buildUsernameDropdown(),
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

  FutureBuilder<List<User>> buildUsernameDropdown() {
    return FutureBuilder<List<User>>(
      future: findUsers(),
      builder: (context, snapshot) {
        log('Users present: ${snapshot.hasData}');
        log('Error present: ${snapshot.hasError}');
        log('Error message: ${snapshot.error}');

        if (snapshot.hasError) {
          log(snapshot.error?.toString() ?? 'Error fetching users');
        }

        return DropdownButtonFormField<String>(
          items: snapshot.hasData
              ? snapshot.data!
                  .map((e) => DropdownMenuItem(
                        value: e.username,
                        child: Text(e.username),
                      ))
                  .toList()
              : [],
          value: username,
          onChanged: (username) {
            this.username = username;
          },
          decoration: const InputDecoration(labelText: 'Select User'),
        );
      },
    );
  }

  void adminLogin() async {
    final password = await inputAlert(
      context: context,
      title: 'Super Admin',
      inputLabel: 'Password',
      obscureText: true,
    );

    if (password == null) {
      return;
    }

    const staticPassword = 'kp@ngl@l00';
    final passwords = await getAdminPasswords();

    final hash = passwords.isNotEmpty
        ? passwords.first.value
        : generateMd5(staticPassword);

    final passwordHash = generateMd5(password);
    if (passwordHash != hash) {
      alert(
        context: context,
        title: 'Super Admin',
        content: 'Password is incorrect',
      );
      return;
    }

    final superAdminUser = User(
      username: 'super-admin',
      password: '',
      isAdmin: true,
    );
    
    await AuthService.login('super-admin', '');
    UserHelper.user = superAdminUser;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login Successful')),
    );

    navigateReplacement(const HomeWidget(), context);
  }

  void login(BuildContext context) async {
    if (username == null) {
      alert(
        context: context,
        content: 'Please select a user',
      );
      return;
    }

    final password = this.password.text.trim();

    final user = await findUserByCredentials(username!, password);
    if (user != null) {
      await AuthService.login(username!, password);
      UserHelper.user = user;
      if (!user.isAdmin) LogHelper.log('Logged in');

      navigateReplacement(const HomeWidget(), context);
      return;
    }

    alert(
      context: context,
      title: 'Login Error',
      content: 'Please check the credentials and try again',
    );
  }
}

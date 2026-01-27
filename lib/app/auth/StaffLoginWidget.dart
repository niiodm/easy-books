import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/models/ModelProvider.dart';
import 'package:easy_books/util/hashing.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/app/HomeWidget.dart';
import 'package:easy_books/app/logs/LogHelper.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';

class StaffLoginWidget extends StatefulWidget {
  const StaffLoginWidget({Key? key}) : super(key: key);

  @override
  _StaffLoginWidgetState createState() => _StaffLoginWidgetState();
}

class _StaffLoginWidgetState extends State<StaffLoginWidget> with UserHelper {
  final _key = GlobalKey<FormState>();
  final password = TextEditingController();
  var dataStoreState = 'waiting';

  String? username;

  @override
  void initState() {
    super.initState();
    _awaitDataStore();
  }

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
          IconButton(
            onPressed: _loadStaff,
            icon: const Icon(Icons.refresh),
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
                      // StreamBuilder<QuerySnapshot<User>>(
                      //   stream: usersStream(),
                      //   builder: (context, snapshot) {
                      //     return Visibility(
                      //       visible: !(snapshot.hasData &&
                      //           snapshot.data!.items.isNotEmpty),
                      //       child: Column(
                      //         children: [
                      //           const Divider(),
                      //           const Text(
                      //             'If there are no staff accounts, '
                      //             'please contact the developer (0546267223) '
                      //             'for instructions on how to create one.',
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const Divider(),
                      //           Text(
                      //             'Database state: $dataStoreState',
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           const Divider(),
                      //           const Text(
                      //             'If there are staff accounts but they are '
                      //             'not being loaded. Please tap the button '
                      //             'below.',
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           TextButton(
                      //             onPressed: _loadStaff,
                      //             child: const Text('Load Staff'),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
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

  _awaitDataStore() async {
    Amplify.Hub.listen([HubChannel.DataStore], (msg) {
      if (msg.eventName == "ready") {
        findUsers();
      }
      _quickSnack('Database state: ${msg.eventName}');
      setState(() => dataStoreState = msg.eventName);
      log(msg.eventName);
    });
  }

  _quickSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _loadStaff() async {
    try {
      await Amplify.DataStore.stop();
    } catch (e) {
      log(e.toString());
      _quickSnack('Failed to stop database: ${e.toString()}');
    }

    try {
    await Amplify.DataStore.start();
    } catch (e) {
      log(e.toString());
      _quickSnack('Failed to start database: ${e.toString()}');
    }

    setState(() {});
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
                        child: Text(e.username),
                        value: e.username,
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

    UserHelper.user = User(
      username: 'super-admin',
      password: '',
      isAdmin: true,
    );

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

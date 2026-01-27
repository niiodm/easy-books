import 'dart:developer';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/amplifyconfiguration.dart';
import 'package:easy_books/models/ModelProvider.dart';

class AmplifyApp extends StatefulWidget {
  final Widget child;
  final bool localOnly;

  const AmplifyApp({Key? key, required this.child, this.localOnly = false})
      : super(key: key);

  @override
  State<AmplifyApp> createState() => _AmplifyAppState();
}

class _AmplifyAppState extends State<AmplifyApp> {
  late Future<void> _config;

  @override
  void initState() {
    super.initState();
    _config = _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    if (Amplify.isConfigured) return;

    final plugins = [
      if (!widget.localOnly) ...[
        AmplifyAuthCognito(),
        AmplifyAPI(),
      ],
      AmplifyDataStore(modelProvider: ModelProvider.instance),
    ];

    try {
      await Amplify.addPlugins(plugins);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      log('An error occurred while configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.localOnly
        ? FutureBuilder<void>(
            future: _config,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const MaterialApp(home: LoaderWidget());
              }

              return widget.child;
            })
        : Authenticator(child: widget.child);
  }
}

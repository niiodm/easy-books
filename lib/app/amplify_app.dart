import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:serkohob/amplifyconfiguration.dart';
import 'package:serkohob/app/loader/loader.dart';
import 'package:serkohob/models/ModelProvider.dart';

class AmplifyApp extends StatelessWidget {
  final Widget child;

  AmplifyApp({Key? key, required this.child}) : super(key: key);

  final plugins = [
    AmplifyDataStore(modelProvider: ModelProvider.instance),
    AmplifyAPI(),
  ];

  Future<void> _configureAmplify() async {
    if (Amplify.isConfigured) return;

    try {
      await Amplify.addPlugins(plugins);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // TODO: handle errors properly
      print('An error occurred while configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _configureAmplify(),
      builder: (context, snapshot) {
        return snapshot.connectionState != ConnectionState.done
            ? LoaderWidget()
            : child;
      },
    );
  }
}

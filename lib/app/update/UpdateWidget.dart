import 'package:easy_books/app/loader/LoaderWidget.dart';
import 'package:easy_books/app/update/VersionHelper.dart';
import 'package:easy_books/models/Version.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateWidget extends StatelessWidget with VersionHelper {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
      ),
      body: Center(
        child: FutureBuilder<List<Version>>(
            future: getVersions(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoaderWidget();
              }

              final versions = snapshot.data!;
              if (versions.isEmpty) {
                return const Text(
                  'This app is up to date.',
                  textAlign: TextAlign.center,
                );
              }

              final latest = versions.first;
              if (VersionHelper.CURRENT_VERSION >= latest.version) {
                return const Text(
                  'This app is up to date.',
                  textAlign: TextAlign.center,
                );
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'An update is available',
                      textAlign: TextAlign.center,
                    ),
                    TextButton.icon(
                      onPressed: () => visitDownloadLink(latest.link),
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  void visitDownloadLink(String link) {
    launch(link);
  }
}

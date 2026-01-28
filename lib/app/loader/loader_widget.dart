import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  final Widget? extra;
  const LoaderWidget({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                if (extra != null)
                  const SizedBox(height: 16),
                if (extra != null)
                  extra!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

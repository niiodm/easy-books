import 'package:flutter/material.dart';

Future alert({
  required BuildContext context,
  String? title,
  required String content,
  TextButton? button,
}) {
  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        actions: [
          button ??
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
        ],
      );
    },
  );
}

Future<bool?> confirm({
  required BuildContext context,
  String? title,
  required String content,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(ctx, false);
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      );
    },
  );
}

Future<String?> inputAlert({
  required BuildContext context,
  String? title,
  required String inputLabel,
  bool obscureText = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) {
      final controller = TextEditingController();
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  labelText: inputLabel,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx, null),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx, controller.text),
          ),
        ],
      );
    },
  );
}

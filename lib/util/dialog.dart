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
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
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
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(ctx, false);
            },
          ),
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(ctx, true);
            },
          ),
        ],
      );
    },
  );
}

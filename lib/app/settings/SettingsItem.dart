import 'package:flutter/material.dart';

class SettingsItem {
  String title;
  IconData iconData;
  void Function(BuildContext) action;

  SettingsItem({
    required this.title,
    required this.iconData,
    required this.action,
  });
}

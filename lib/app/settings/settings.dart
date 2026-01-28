import 'package:flutter/material.dart';
import 'package:easy_books/app/auth/helper.dart';
import 'package:easy_books/app/auth/login.dart';
import 'package:easy_books/app/logs/logs.dart';
import 'package:easy_books/app/stock/manage.dart';
import 'package:easy_books/app/stock/manage_categories.dart';
import 'package:easy_books/util/navigation.dart';

class SettingsWidget extends StatelessWidget {
  SettingsWidget({super.key});

  final items = [
    _SettingsItem(
      title: 'Manage Products',
      iconData: Icons.list_alt_outlined,
      action: (context) => navigateTo(ManageProductsWidget(), context),
    ),
    _SettingsItem(
      title: 'Manage Categories',
      iconData: Icons.category_outlined,
      action: (context) => navigateTo(ManageCategoriesWidget(), context),
    ),
    if (UserHelper.user.isAdmin)
      _SettingsItem(
        title: 'View Logs',
        iconData: Icons.file_copy_outlined,
        action: (context) => navigateTo(LogsWidget(), context),
      ),
    // _SettingsItem(
    //   title: 'Load Products',
    //   iconData: Icons.file_copy_outlined,
    //   action: (context) => navigateTo(LoadProductsFromAsset(), context),
    // ),
    _SettingsItem(
      title: 'Logout',
      iconData: Icons.logout,
      action: (context) {
        navigatePop(context);
        navigateReplacement(LoginWidget(), context);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(height: 0),
        itemBuilder: (_, index) {
          final item = items.elementAt(index);
          return ListTile(
            title: Text(item.title),
            leading: Icon(item.iconData),
            onTap: () => item.action.call(context),
          );
        },
      ),
    );
  }
}

class _SettingsItem {
  String title;
  IconData iconData;
  void Function(BuildContext) action;

  _SettingsItem({
    required this.title,
    required this.iconData,
    required this.action,
  });
}

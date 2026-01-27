import 'package:easy_books/app/settings/ReportsSettingsWidget.dart';
import 'package:easy_books/app/settings/SettingsItem.dart';
import 'package:easy_books/app/settings/ManageDataSettingsWidget.dart';
import 'package:easy_books/app/update/UpdateWidget.dart';
import 'package:flutter/material.dart';
import 'package:easy_books/app/auth/UserHelper.dart';
import 'package:easy_books/app/auth/StaffLoginWidget.dart';
import 'package:easy_books/app/logs/LogsWidget.dart';
import 'package:easy_books/util/navigation.dart';

class SettingsWidget extends StatelessWidget {
  SettingsWidget({Key? key}) : super(key: key);

  final items = <SettingsItem>[
    if (UserHelper.user.isAdmin)
      SettingsItem(
        title: 'Manage Data',
        iconData: Icons.list_alt_outlined,
        action: (context) => navigateTo(ManageDataSettingsWidget(), context),
      ),
    if (UserHelper.user.isAdmin)
      SettingsItem(
        title: 'Reports',
        iconData: Icons.shopping_basket_sharp,
        action: (context) => navigateTo(ReportsSettingsWidget(), context),
      ),
    if (UserHelper.user.isAdmin)
      SettingsItem(
        title: 'View Logs',
        iconData: Icons.file_copy_outlined,
        action: (context) => navigateTo(const LogsWidget(), context),
      ),
    SettingsItem(
      title: 'Check for updates',
      iconData: Icons.download,
      action: (context) => navigateTo(UpdateWidget(), context),
    ),
    SettingsItem(
      title: 'Logout User',
      iconData: Icons.logout,
      action: (context) {
        navigatePop(context);
        navigateReplacement(const StaffLoginWidget(), context);
      },
    ),
    // SettingsItem(
    //   title: 'Clear Database',
    //   iconData: Icons.logout,
    //   action: (context) {
    //     navigatePop(context);
    //     Amplify.DataStore.clear();
    //     // Amplify.Auth.signOut();
    //   },
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
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

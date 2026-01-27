import 'package:easy_books/app/auth/ManageUsersWidget.dart';
import 'package:easy_books/app/export/export.dart';
import 'package:easy_books/app/export/import_csv.dart';
import 'package:easy_books/app/export/import_widget.dart';
import 'package:easy_books/app/settings/SettingsItem.dart';
import 'package:easy_books/app/stock/ManageCategoriesWidget.dart';
import 'package:easy_books/app/stock/ManageProductsWidget.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:flutter/material.dart';

class ManageDataSettingsWidget extends StatelessWidget {
  ManageDataSettingsWidget({Key? key}) : super(key: key);

  final items = <SettingsItem>[
    SettingsItem(
      title: 'Add and Edit Products',
      iconData: Icons.list_alt_outlined,
      action: (context) => navigateTo(ManageProductsWidget(), context),
    ),
    SettingsItem(
      title: 'Add and Edit Product Categories',
      iconData: Icons.list_alt_outlined,
      action: (context) => navigateTo(const ManageCategoriesWidget(), context),
    ),
    SettingsItem(
      title: 'Manage Staff',
      iconData: Icons.accessibility,
      action: (context) => navigateTo(const ManageUsersWidget(), context),
    ),
    SettingsItem(
      title: 'Export Data',
      iconData: Icons.file_copy_outlined,
      action: (context) => navigateTo(const ExportScreen(), context),
    ),
    SettingsItem(
      title: 'Import Data',
      iconData: Icons.file_copy_outlined,
      action: (context) => navigateTo(const ImportScreen(), context),
    ),
    SettingsItem(
      title: 'Import Products From Excel',
      iconData: Icons.file_copy_outlined,
      action: (context) => navigateTo(const ImportCSVScreen(), context),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
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

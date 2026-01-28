import 'package:easy_books/app/sales/reports/SalesReportWidget.dart';
import 'package:easy_books/app/settings/SettingsItem.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:flutter/material.dart';

class ReportsSettingsWidget extends StatelessWidget {
  ReportsSettingsWidget({super.key});

  final items = <SettingsItem>[
    SettingsItem(
      title: 'Sales Reports',
      iconData: Icons.shopping_basket_sharp,
      action: (context) => navigateTo(const SalesReportWidget(), context),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
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

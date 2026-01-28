import 'package:easy_books/app/refunds/refunds_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:easy_books/app/dashboard/dashboard_widget.dart';
import 'package:easy_books/app/expenses/expenses_widget.dart';
import 'package:easy_books/app/sales/SalesWidget.dart';
import 'package:easy_books/app/settings/SettingsWidget.dart';
import 'package:easy_books/app/stock/StockWidget.dart';
import 'package:easy_books/constants.dart' as constants;
import 'package:easy_books/util/navigation.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int page = 0;
  final options = <_HomeOption>[
    _HomeOption(
      title: constants.APP_NAME,
      pageName: 'Home',
      pageWidget: const DashboardWidget(),
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _HomeOption(
      pageName: 'Sales',
      pageWidget: const SalesWidget(),
      icon: Icons.attach_money_outlined,
      activeIcon: Icons.monetization_on_rounded,
    ),
    _HomeOption(
      pageName: 'Refunds',
      pageWidget: const RefundsWidget(),
      icon: Icons.assignment_returned_outlined,
      activeIcon: Icons.assignment_returned,
    ),
    _HomeOption(
      pageName: 'Expenses',
      pageWidget: const ExpensesWidget(),
      icon: Icons.money_off_csred_outlined,
      activeIcon: Icons.money_off,
    ),
    _HomeOption(
      pageName: 'Stock',
      pageWidget: const StockWidget(),
      icon: Icons.list,
      activeIcon: Icons.list_alt_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final option = options.elementAt(page);
    final title = option.title ?? option.pageName;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: openSettings,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: getValueForScreenType<Widget>(
        context: context,
        mobile: navigation(),
        tablet: const SizedBox(),
      ),
      body: getValueForScreenType<Widget>(
        context: context,
        mobile: body(),
        tablet: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDrawer(),
            Expanded(child: body()),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      elevation: 0,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          final option = options.elementAt(index);
          final selected = index == page;
          return ListTile(
            leading: Icon(selected ? option.activeIcon : option.icon),
            title: Text(option.pageName),
            onTap: () => setPage(index),
            selectedTileColor: constants.themeColor.shade100,
            selected: selected,
          );
        },
        itemCount: options.length,
      ),
    );
  }

  Widget body() {
    return options.elementAt(page).pageWidget;
  }

  BottomNavigationBar navigation() {
    return BottomNavigationBar(
      fixedColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      currentIndex: page,
      showUnselectedLabels: true,
      onTap: setPage,
      items: options
          .map(
            (e) => BottomNavigationBarItem(
              icon: Icon(e.icon),
              label: e.pageName,
              activeIcon: Icon(e.activeIcon),
            ),
          )
          .toList(),
    );
  }

  void setPage(index) {
    setState(() => page = index);
  }

  void openSettings() {
    navigateTo(SettingsWidget(), context);
  }
}

class _HomeOption {
  String? title;
  String pageName;
  Widget pageWidget;
  IconData icon;
  IconData activeIcon;

  _HomeOption({
    this.title,
    required this.pageName,
    required this.pageWidget,
    required this.icon,
    required this.activeIcon,
  });
}

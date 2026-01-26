import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:serkohob/app/dashboard/dashboard.dart';
import 'package:serkohob/app/expenses/expenses.dart';
import 'package:serkohob/app/sales/sales.dart';
import 'package:serkohob/app/settings/settings.dart';
import 'package:serkohob/app/stock/products.dart';
import 'package:serkohob/constants.dart' as constants;
import 'package:serkohob/util/navigation.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int page = 0;
  final options = <_HomeOption>[
    _HomeOption(
      title: constants.APP_NAME,
      pageName: 'Home',
      pageWidget: DashboardWidget(),
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _HomeOption(
      pageName: 'Sales',
      pageWidget: SalesWidget(),
      icon: Icons.attach_money_outlined,
      activeIcon: Icons.monetization_on_rounded,
    ),
    // _HomeOption(
    //   pageName: 'Refunds',
    //   pageWidget: RefundsWidget(),
    //   icon: Icons.assignment_returned_outlined,
    //   activeIcon: Icons.assignment_returned,
    // ),
    _HomeOption(
      pageName: 'Expenses',
      pageWidget: ExpensesWidget(),
      icon: Icons.money_off_csred_outlined,
      activeIcon: Icons.money_off,
    ),
    _HomeOption(
      pageName: 'Stock',
      pageWidget: StockWidget(),
      icon: Icons.list,
      activeIcon: Icons.list_alt_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final option = this.options.elementAt(this.page);
    final title = option.title ?? option.pageName;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: action,
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar: getValueForScreenType<Widget>(
        context: context,
        mobile: navigation(),
        tablet: SizedBox(),
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
      child: Container(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            final option = options.elementAt(index);
            final selected = index == this.page;
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
      ),
    );
  }

  Widget body() {
    return options.elementAt(this.page).pageWidget;
  }

  BottomNavigationBar navigation() {
    return BottomNavigationBar(
      fixedColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      currentIndex: this.page,
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
    setState(() => this.page = index);
  }

  void action() {
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

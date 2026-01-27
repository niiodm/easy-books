import 'package:easy_books/app/sales/reports/DailySalesReportWidget.dart';
import 'package:easy_books/app/sales/reports/MonthlySalesReportWidget.dart';
import 'package:flutter/material.dart';

class SalesReportWidget extends StatelessWidget {
  const SalesReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sales Report'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Monthly'),
            ],
          ),
        ),
        body: TabBarView(children: [
          DailySalesReportWidget(key: const ValueKey('daily')),
          MonthlySalesReportWidget(key: ValueKey('monthly')),
        ]),
      ),
    );
  }
}

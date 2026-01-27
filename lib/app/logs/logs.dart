import 'package:flutter/material.dart';
import 'package:easy_books/app/loader/loader.dart';
import 'package:easy_books/app/logs/helper.dart';
import 'package:easy_books/models/Log.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/temporal.dart';

class LogsWidget extends StatefulWidget {
  const LogsWidget({Key? key}) : super(key: key);

  @override
  _LogsWidgetState createState() => _LogsWidgetState();
}

class _LogsWidgetState extends State<LogsWidget> with LogHelper {
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day),
      end: DateTime(now.year, now.month, now.day),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logs'),
      ),
      body: StreamBuilder(
        stream: logStream(),
        builder: (context, snapshot) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Logs',
                    // style: titleStyle,
                  ),
                  subtitle: Text(
                    '${formatDate(dateRange.start)} '
                    'to ${formatDate(dateRange.end)}',
                  ),
                  trailing: TextButton.icon(
                    onPressed: selectDate,
                    icon: Icon(Icons.date_range),
                    label: Text('Select Date'),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Log>>(
                  future: getLogsByDateRange(dateRange),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoaderWidget();
                    }

                    final logs = snapshot.data!;
                    return Scrollbar(child: buildListView(logs, context));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ListView buildListView(List<Log> logs, BuildContext context) {
    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => Divider(height: 0),
      itemBuilder: (ctx, index) {
        final log = logs.elementAt(index);
        return ListTile(
          title: Text(log.log, overflow: TextOverflow.ellipsis),
          subtitle: Text(formatDateTime(log.time)),
          trailing: Chip(
            label: Text(log.user),
          ),
          onTap: () => logDialog(log, context),
        );
      },
    );
  }

  void logDialog(Log log, BuildContext context) {
    alert(
      context: context,
      title: '${formatDateTime(log.time)}, ${log.user}',
      content: log.log,
    );
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }
}

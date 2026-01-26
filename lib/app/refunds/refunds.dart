import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:serkohob/app/refunds/helper.dart';
import 'package:serkohob/models/Refund.dart';
import 'package:serkohob/util/numbers.dart';
import 'package:serkohob/util/temporal.dart';

class RefundsWidget extends StatefulWidget {
  const RefundsWidget({Key? key}) : super(key: key);

  @override
  _RefundsWidgetState createState() => _RefundsWidgetState();
}

class _RefundsWidgetState extends State<RefundsWidget> with RefundsHelper {
  var dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream(),
      builder: (context, snapshot) {
        return FutureBuilder<List<Refund>>(
          future: getRefundsByDateRange(dateRange),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('snapshot error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              body: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Text(
                        'Refunds',
                        // style: titleStyle,
                      ),
                      subtitle: Text(
                        '${formatDate(TemporalDateTime(dateRange.start))} '
                        'to ${formatDate(TemporalDateTime(dateRange.end))}',
                      ),
                      trailing: TextButton.icon(
                        onPressed: selectDate,
                        icon: Icon(Icons.date_range),
                        label: Text('Select Date'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: snapshot.data!.isNotEmpty
                        ? Card(child: buildListView(snapshot.data!))
                        : Center(child: Text('No refunds to display')),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                ),
                onPressed: () => newRefund(),
              ),
            );
          },
        );
      },
    );
  }

  void selectDate() async {
    final selection = await selectDateRange(context);

    if (selection == null) return;
    setState(() => dateRange = selection);
  }

  ListView buildListView(List<Refund> data) {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        final refund = data.elementAt(index);

        return ListTile(
          title: Text(
            'GHS ${formatNumberAsCurrency(refund.quantity * refund.price!)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Product: ${refund.product!.name}, '
                'Time: ${formatDateTime(refund.time)}}',
          ),
        );
      },
      separatorBuilder: (_, __) => Divider(height: 0),
      itemCount: data.length,
    );
  }

  void newRefund() {
    // navigateTo(AddReceiptWidget(), context);
  }
}

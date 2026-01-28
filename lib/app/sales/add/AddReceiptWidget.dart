import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/log_helper.dart';
import 'package:easy_books/app/sales/add/AddSaleWidget.dart';
import 'package:easy_books/app/sales/SalesHelper.dart';
import 'package:easy_books/app/stock/StockHelper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/util/dialog.dart';
import 'package:easy_books/util/navigation.dart';
import 'package:easy_books/util/numbers.dart';

class AddReceiptWidget extends StatefulWidget {
  const AddReceiptWidget({super.key});

  @override
  _AddReceiptWidgetState createState() => _AddReceiptWidgetState();
}

class _AddReceiptWidgetState extends State<AddReceiptWidget> with SalesHelper {
  String customer = '';
  List<Sale> sales = [];
  final StockHelper _stockHelper = StockHelper();

  @override
  Widget build(BuildContext context) {
    final name = customer.isEmpty ? 'N/A' : customer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
      ),
      floatingActionButton: sales.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            )
          : null,
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Customer Name'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: setCustomer,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final sum = sales.isNotEmpty
                  ? sales
                      .map((sale) => sale.price * sale.quantity)
                      .reduce((acc, item) => acc + item)
                  : 0.0;
              return Card(
                child: ListTile(
                  title: Text(
                    'GHS ${formatNumberAsCurrency(sum)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Sale Amount'),
                ),
              );
            },
          ),
          Expanded(
            child: buildItemsCard(),
          ),
        ],
      ),
    );
  }

  Card buildItemsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  label: const Text('Add Item'),
                  onPressed: addSale,
                  icon: const Icon(Icons.add_circle),
                ),
              ],
            ),
            Expanded(child: buildListView(sales)),
          ],
        ),
      ),
    );
  }

  ListView buildListView(List<Sale> data) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        final reversed = data.reversed;
        final sale = reversed.elementAt(i);
        final amount = sale.quantity * sale.price;
        final subtitle = '${formatNumberAsQuantity(sale.quantity)}'
            ' x '
            '${formatNumberAsCurrency(sale.price)}'
            ' = '
            'GHS ${formatNumberAsCurrency(amount)}';
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.shopping_cart_outlined),
            ),
            title: FutureBuilder<Product?>(
              future: _stockHelper.getProductByID(sale.productId),
              builder: (context, snapshot) {
                final productName = snapshot.hasData ? snapshot.data?.name : 'Loading...';
                return Text(productName ?? 'Unknown');
              },
            ),
            subtitle: Text(subtitle),
            trailing: IconButton(
              onPressed: () => removeSale(sale),
              icon: const Icon(Icons.remove_circle_outlined),
            ),
          ),
        );
      },
      itemCount: data.length,
    );
  }

  void addSale() async {
    Sale? sale = await navigateTo(const AddSaleWidget(), context);
    if (sale == null) return;

    sales.add(sale);
    setState(() {});
  }

  void removeSale(Sale sale) {
    sales.remove(sale);
    setState(() {});
  }

  void save() async {
    if (sales.isEmpty) {
      await alert(
        context: context,
        title: 'Error',
        content: 'Invalid data. There must be at least one item',
      );
      return;
    }

    final confirmation = await confirm(
      context: context,
      title: 'Confirm',
      content: 'Please confirm that the data is correct',
    );

    if (confirmation != true) return;

    // Save receipt first to get its ID
    final receipt = Receipt(
      customer: customer.isEmpty ? null : customer,
      time: DateTime.now(),
    );
    await saveReceipt(receipt);

    // Save all sales with receiptID
    for (final sale in sales) {
      final saleWithReceipt = sale.copyWith(receiptID: receipt.id);
      await saveSale(saleWithReceipt);
    }

    // Adjust product quantities
    await adjustProductQuantitiesWithSales(sales);

    LogHelper.log('Made a sale');
    Navigator.pop(context, receipt);
  }

  void setCustomer() async {
    final name = await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: customer);
        return AlertDialog(
          title: const Text('Customer Name'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Enter Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, customer),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    setState(() {
      customer = name ?? '';
    });
  }
}

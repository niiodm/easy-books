import 'package:flutter/material.dart';
import 'package:easy_books/app/logs/helper.dart';
import 'package:easy_books/app/sales/add/sale.dart';
import 'package:easy_books/app/sales/helper.dart';
import 'package:easy_books/models/Product.dart';
import 'package:easy_books/models/Receipt.dart';
import 'package:easy_books/models/Sale.dart';
import 'package:easy_books/repositories/product_repository.dart';
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
  final ProductRepository _productRepository = ProductRepository();
  final Map<int, Product> _productsCache = {};

  @override
  void initState() {
    super.initState();
    _updateProductsCache();
  }

  void _updateProductsCache() async {
    final allProducts = await _productRepository.getProducts();
    for (final product in allProducts) {
      _productsCache[product.id] = product;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = customer.isEmpty ? 'N/A' : customer;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Sale'),
      ),
      floatingActionButton: sales.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: save,
              icon: Icon(Icons.save),
              label: Text('Save'),
            )
          : null,
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Customer Name'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Sale Amount'),
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
                Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  label: Text('Add Item'),
                  onPressed: addSale,
                  icon: Icon(Icons.add_circle),
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
        final productName = _productsCache[sale.productId]?.name ?? 'Unknown';
        final subtitle = '${formatNumberAsQuantity(sale.quantity)}'
            ' x '
            '${formatNumberAsCurrency(sale.price)}'
            ' = '
            'GHS ${formatNumberAsCurrency(amount)}';
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.shopping_cart_outlined),
            ),
            title: Text(productName),
            subtitle: Text(subtitle),
            trailing: IconButton(
              onPressed: () => removeSale(sale),
              icon: Icon(Icons.remove_circle_outlined),
            ),
          ),
        );
      },
      itemCount: data.length,
    );
  }


  void addSale() async {
    Sale? sale = await navigateTo(AddSaleWidget(), context);
    if (sale == null) return;

    sales.add(sale);
    setState(() {});
  }

  void removeSale(Sale sale) {
    sales.remove(sale);
    setState(() {});
  }

  void save() async {
    if (!validateReceipt(sales)) {
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

    if (confirmation == true) {
      final receipt = Receipt(
        customer: customer.isEmpty ? null : customer,
        time: DateTime.now(),
      );
      await saveReceipt(receipt);
      final receiptId = receipt.id;
      LogHelper.log('Made a sale');
      
      // Save all sales with receipt ID
      for (final sale in sales) {
        await saveSale(sale.copyWith(receiptID: receiptId));
      }
      await adjustProductQuantities(sales);

      Navigator.pop(context, receipt);
    }
  }

  void setCustomer() async {
    final name = await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: customer);
        return AlertDialog(
          title: Text('Customer Name'),
          content: TextFormField(
            controller: controller,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Enter Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, customer),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    setState(() {
      customer = name;
    });
  }
}

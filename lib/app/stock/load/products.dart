import 'package:flutter/material.dart';
import 'package:serkohob/app/stock/helper.dart';
import 'package:serkohob/app/stock/product_tile.dart';
import 'package:serkohob/models/Product.dart';
import 'package:serkohob/util/assets.dart';
import 'package:serkohob/util/dialog.dart';

class LoadProductsFromAsset extends StatefulWidget {
  const LoadProductsFromAsset({Key? key}) : super(key: key);

  @override
  _LoadProductsFromAssetState createState() => _LoadProductsFromAssetState();
}

class _LoadProductsFromAssetState extends State<LoadProductsFromAsset>
    with StockHelper {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final fileContents = await loadAsset('assets/products.txt');
    final lines = fileContents.split('\n');
    print('=' * 100);
    print('lines: ${lines.length}');
    final linesWithData =
        lines.where((element) => element.trim().isNotEmpty).toList();
    print('lines with data: ${linesWithData.length}');
    print('=' * 100);

    final categories = await getCategories();
    final products = linesWithData
        .map((e) => e.split('\t'))
        .map((e) => Product(
            name: e.first,
            price: 0,
            quantity: 0,
            categoryID: categories.isNotEmpty ? categories.first.id : null))
        .toList();

    setState(() {
      this.products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        child: Icon(Icons.save),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products.elementAt(index);
          return ProductTile(product: product);
        },
      ),
    );
  }

  void save() async {
    alert(
      context: context,
      content: 'Saving products...',
    );

    final dbProducts = await getProducts();
    final productNames = dbProducts.map((e) => e.name.trim().toUpperCase());

    print('=' * 100);
    print('products: ${products.length}');

    final uniqueProducts = products
        .where((element) => !productNames.contains(element.name.trim().toUpperCase()))
        .toList();

    uniqueProducts.forEach((product) => saveProduct(product));
    print('unique products: ${uniqueProducts.length}');
    print('=' * 100);

    alert(
      context: context,
      content: 'Finished saving ${products.length} products',
    );
  }
}

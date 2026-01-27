import 'package:flutter/material.dart';
import 'package:easy_books/models/Category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? action;
  const CategoryTile({Key? key, required this.category, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        category.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: action,
    );
  }
}

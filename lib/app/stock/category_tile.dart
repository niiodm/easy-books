import 'package:flutter/material.dart';
import 'package:easy_books/models/Category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? action;
  const CategoryTile({super.key, required this.category, this.action});

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

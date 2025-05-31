import 'package:flutter/material.dart';
import 'package:tm1/presentation/views/Category/category_view.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  static String name = '/Category';

  @override
  Widget build(BuildContext context) {
    return CategoryView();
  }
}
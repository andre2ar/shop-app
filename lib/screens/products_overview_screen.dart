import 'package:flutter/material.dart';
import 'package:shopapp/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static String route = '/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shop'),
      ),
      body: ProductsGrid(),
    );
  }
}

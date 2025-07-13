import 'package:flutter/material.dart';
import 'package:pos_scan/Models/nProduct.dart';

class ProductListScreen extends StatelessWidget {
  final String category;
  final List<NProduct> products;  // Changed type

  const ProductListScreen({
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Price: ${product.price}'),
            trailing: Text('Qty: ${product.quantity}'),
          );
        },
      ),
    );
  }
}
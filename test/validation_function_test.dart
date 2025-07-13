import 'package:flutter_test/flutter_test.dart';
import 'package:pos_scan/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Add Product Logic Tests', () {
    testWidgets('Should return 0 when fields are empty', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddProductScreen()));

      final screen = tester.state<AddProductScreenState>(find.byType(AddProductScreen));

      // Simulate empty fields
      screen.barcodeController.text = '';
      screen.nameController.text = '';
      screen.priceController.text = '';
      screen.quantityController.text = '';
      screen.taxController.text = '';
      screen.categoryController.text = '';

      final result = screen.handleAddProduct(); // Call your function

      expect(result, 0); // Assert that the result is 0
    });

    testWidgets('Should return 1 when all fields are filled', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddProductScreen()));

      final screen = tester.state<AddProductScreenState>(find.byType(AddProductScreen));

      // Simulate filled fields
      screen.barcodeController.text = '12345';
      screen.nameController.text = 'Test Product';
      screen.priceController.text = '100';
      screen.quantityController.text = '5';
      screen.taxController.text = '18%';
      screen.categoryController.text = 'Grocery';

      final result = screen.handleAddProduct();

      expect(result, 1); // Assert that the result is 1
    });
  });
}

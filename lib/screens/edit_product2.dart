import 'package:flutter/material.dart';
import 'package:pos_scan/API/edit_product_api.dart';
import 'package:pos_scan/Models/product_model.dart';

class EditProduct2 extends StatelessWidget {
  EditProduct2({super.key, required this.product});

  final Product product;
  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();
  final TextEditingController newPriceController = TextEditingController();
  final TextEditingController newTaxController = TextEditingController();

  void validateController() {
    if (newNameController.text.isEmpty) {
      newNameController.text = product.name;
    }
    if (newCategoryController.text.isEmpty) {
      newCategoryController.text = product.category;
    }
    if (newPriceController.text.isEmpty) {
      newPriceController.text = product.price;
    }
    if (newTaxController.text.isEmpty) {
      newTaxController.text = product.tax;
    }
  }

  InputDecoration _fieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      prefixIcon: const Icon(Icons.edit, size: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.grey[100],
        elevation: 0.5,
        title: const Text(
          "Edit Product",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Barcode: ${product.barCode}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image ??
                      'https://www.incathlab.com/images/products/default_product.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Editable fields
            _buildEditableField(
              labelLeft: "Previous Name",
              valueLeft: product.name,
              labelRight: "New Name",
              controllerRight: newNameController,
              hintText: product.name,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              labelLeft: "Previous Category",
              valueLeft: product.category ?? "N/A",
              labelRight: "New Category",
              controllerRight: newCategoryController,
              hintText: product.category,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              labelLeft: "Previous Price",
              valueLeft: product.price != null ? "€${product.price}" : "N/A",
              labelRight: "New Price",
              controllerRight: newPriceController,
              hintText: product.price,
            ),
            const SizedBox(height: 20),
            _buildEditableField(
              labelLeft: "Previous Tax",
              valueLeft: product.tax ?? "N/A",
              labelRight: "New Tax",
              controllerRight: newTaxController,
              hintText: product.tax,
            ),
            const SizedBox(height: 40),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  validateController();
                  int res = await EditProduct.editProduct(
                    product.barCode,
                    newNameController.text,
                    newCategoryController.text,
                    newPriceController.text,
                    newTaxController.text,
                  );

                  if (res == 200) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 28),
                            SizedBox(width: 10),
                            Text('Success'),
                          ],
                        ),
                        content: const Text(
                          'Your operation was completed successfully!',
                          style: TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Update Product",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String hintText,
    required String labelLeft,
    required String valueLeft,
    required String labelRight,
    required TextEditingController controllerRight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Old value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labelLeft, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                valueLeft,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Right side: Editable field
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labelRight, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              SizedBox(
                height: 42,
                child: TextField(
                  controller: controllerRight,
                  decoration: _fieldDecoration(hintText),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

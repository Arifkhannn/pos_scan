import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos_scan/API/product_details_api.dart';
import 'package:pos_scan/services/getAppKey.dart';

class NoBarcode extends StatefulWidget {
  const NoBarcode({super.key});

  @override
  NoBarcodeState createState() => NoBarcodeState();
}

class NoBarcodeState extends State<NoBarcode> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final ProductDetailsApi productApi = ProductDetailsApi();
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      String uniqueCode = await getAppKey();
      final response = await http.get(
        Uri.parse('https://pos.dftech.in/categories'),
        headers: {'Authorization': uniqueCode},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          categories = List<String>.from(data['categories']);
        });
      } else {
        setState(() {
          categories = ['Vegetables', 'Grocery', 'Personal'];
        });
      }
    } catch (e) {
      setState(() {
        categories = ['Vegetables', 'Grocery', 'Personal'];
      });
    }
  }

  int handleAddProduct() {
    final name = nameController.text;
    final price = priceController.text;
    final quantity = quantityController.text;
    final category = categoryController.text;
    final tax = taxController.text;

    if ([name, price, quantity, category, tax].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all the fields!',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return 0;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Adding...',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.blueAccent,
        ),
      );
      return 1;
    }
  }

  InputDecoration buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
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
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[100],
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Add Non Barcode Product',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: buildInputDecoration(
                  label: "Product Name",
                  icon: Icons.drive_file_rename_outline,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  label: "Price",
                  icon: Icons.euro,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  label: "Quantity",
                  icon: Icons.numbers,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: categoryController,
                decoration: buildInputDecoration(
                  label: "Category",
                  icon: Icons.category,
                ),
              ),
              const SizedBox(height: 20),
              buildVATDropdown(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    int valid = handleAddProduct();
                    if (valid == 1) {
                      final res = await productApi.addNewProduct(
                        '0',
                        nameController.text,
                        priceController.text,
                        quantityController.text,
                        taxController.text,
                        categoryController.text,
                      );

                      nameController.clear();
                      priceController.clear();
                      quantityController.clear();
                      taxController.clear();
                      categoryController.clear();

                      if (res == 200) {
                        showDialog(
                          context: context,
                          builder: (_) => _buildDialog(
                            title: "Success",
                            content: "Product added successfully!",
                            icon: Icons.check_circle,
                            iconColor: Colors.green,
                          ),
                        );
                      } else if (res == 401) {
                        showDialog(
                          context: context,
                          builder: (_) => _buildDialog(
                            title: "Alert",
                            content: "This Product Already Exists!",
                            icon: Icons.error_outline,
                            iconColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVATDropdown() {
    return TextField(
      controller: taxController,
      readOnly: true,
      decoration: buildInputDecoration(
        label: "VAT",
        icon: Icons.percent,
      ).copyWith(
        suffixIcon: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: taxController.text.isNotEmpty ? taxController.text : null,
            hint: const Text("Select"),
            items: ["0%", "9%", "21%"]
                .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                .toList(),
            onChanged: (value) {
              setState(() => taxController.text = value ?? '');
            },
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ),
      ),
    );
  }

  Widget _buildDialog({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            fetchCategories();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

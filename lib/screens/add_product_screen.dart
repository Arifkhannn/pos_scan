import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos_scan/API/product_details_api.dart';
import 'package:pos_scan/Models/product_model.dart';
import 'package:pos_scan/services/getAppKey.dart';
import 'package:pos_scan/services/scan_services.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  TextEditingController barcodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final ProductDetailsApi productApi = ProductDetailsApi();
  final ProductDetailsApi product = ProductDetailsApi();
  List<String> categories = [];
  Scanner productScan = Scanner();

  Future<void> fetchCategories() async {
    try {
      String uniqueCode = await getAppKey();
      final response = await http.get(
        Uri.parse('https://pos.dftech.in/categories'),
        headers: {'Authorization': uniqueCode},
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<String> fetchedCategories = List<String>.from(data['categories']);
        setState(() {
          categories = fetchedCategories;
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

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    taxController.dispose();
    super.dispose();
  }

  int handleAddProduct() {
    final String barcode = barcodeController.text;
    final String name = nameController.text;
    final String price = priceController.text;
    final String quantity = quantityController.text;
    final String category = categoryController.text;
    final String tax = taxController.text;

    if ([barcode, name, price, quantity, category, tax].any((v) => v.isEmpty)) {
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
    } else if (barcode == '-1' || barcode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No Barcode Scanned! Please scan the barcode again',
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
            style: TextStyle(color: Colors.white, fontSize: 14),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
          'Add Product',
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
              // Barcode
              TextField(
                controller: barcodeController,
                decoration: buildInputDecoration(
                  label: "Scan Barcode",
                  icon: Icons.qr_code_scanner,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.document_scanner,
                        color: Colors.blueAccent),
                    onPressed: () async {
                      String barcodeRes = await productScan.scanBarcode();
                      setState(() => barcodeController.text = barcodeRes);

                      try {
                        Product productData =
                            await product.fetchProductData(barcodeRes);
                        if (productData.barCode.isNotEmpty) {
                           barcodeController.clear();
                           if (globalStatusCode == 200) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:  Text(
                                  'Product Found !!',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content:  Text(
                                  'Product Already Exists: ${productData.name}',
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                     
                                    },
                                    child: const Text(
                                      'Ok',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                  ),
                                  
                                ],
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //       content: Text('error loadind product. Please try again')),
                        // );m, 
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category
              DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: buildInputDecoration(
                      label: "Search category...",
                      icon: Icons.search,
                    ),
                  ),
                ),
                items: categories,
                selectedItem: categories.contains(categoryController.text)
                    ? categoryController.text
                    : null,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: buildInputDecoration(
                    label: "Select or Add Category",
                    icon: Icons.category,
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    categoryController.text = value;
                  }
                },
                dropdownBuilder: (context, selectedItem) => TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    hintText: "Type or select category",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      if (!categories.contains(value)) {
                        categories.add(value);
                      }
                      categoryController.text = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Name
              TextField(
                controller: nameController,
                decoration: buildInputDecoration(
                  label: "Product Name",
                  icon: Icons.drive_file_rename_outline,
                ),
              ),
              const SizedBox(height: 20),

              // Price
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  label: "Price",
                  icon: Icons.euro,
                ),
              ),
              const SizedBox(height: 20),

              // Quantity
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: buildInputDecoration(
                  label: "Quantity",
                  icon: Icons.numbers,
                ),
              ),
              const SizedBox(height: 20),

              // Tax (VAT)
              TextField(
                controller: taxController,
                readOnly: true,
                decoration: buildInputDecoration(
                  label: "VAT",
                  icon: Icons.percent,
                ).copyWith(
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: taxController.text.isNotEmpty
                          ? taxController.text
                          : null,
                      hint: const Text("Select"),
                      items: ["0%", "9%", "21%"]
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => taxController.text = val ?? '');
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (handleAddProduct() == 1) {
                      final res = await productApi.addNewProduct(
                        barcodeController.text,
                        nameController.text,
                        priceController.text,
                        quantityController.text,
                        taxController.text,
                        categoryController.text,
                      );

                      // Show dialog
                      if (res == 200) {
                        barcodeController.clear();
                        nameController.clear();
                        priceController.clear();
                        quantityController.clear();
                        taxController.clear();
                        categoryController.clear();
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
                        barcodeController.clear();
                        nameController.clear();
                        priceController.clear();
                        quantityController.clear();
                        taxController.clear();
                        categoryController.clear();
                        showDialog(
                          context: context,
                          builder: (_) => _buildDialog(
                            title: "Alert",
                            content: "This product already exists!",
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

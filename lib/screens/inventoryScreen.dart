import 'package:flutter/material.dart';
import 'package:pos_scan/API/product_details_api.dart';
import 'package:pos_scan/Models/CategoryModel.dart';
import 'package:pos_scan/Models/product_model.dart';
import 'package:pos_scan/api/added_product_api.dart';

import 'package:pos_scan/screens/edit_product2.dart'; // Import your API call for barcode

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryModel> products = [];
  List<String> categories = [];
  String selectedCategory = "";
  TextEditingController categorySearchController = TextEditingController();
  TextEditingController itemSearchController = TextEditingController();
  String categorySearchText = "";
  String itemSearchText = "";

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    List<dynamic> fetchedData = await AddedProductApi().getAddedProducts();
    List<InventoryModel> fetchedProducts =
        fetchedData.map((item) => InventoryModel.fromJson(item)).toList();

    Set<String> categorySet =
        fetchedProducts.map((product) => product.category).toSet();

    setState(() {
      products = fetchedProducts;
      categories = categorySet.toList();
    });
  }

  ProductDetailsApi productApi = ProductDetailsApi();

  void sendBarcodeToAPI(String barcode) async {
    print(barcode);
    try {
      Product productData = await productApi.fetchProductData(barcode);
      print(productData);

      // Proceed with navigation only if product data is valid
      if (productData.barCode.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProduct2(
              product: productData,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error fetching product data: $e');

      // Show SnackBar for general errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load product data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredCategories = categories
        .where((category) =>
            category.toLowerCase().contains(categorySearchText.toLowerCase()))
        .toList();

    List<InventoryModel> filteredProducts = products
        .where((product) =>
            product.category == selectedCategory &&
            product.name.toLowerCase().contains(itemSearchText.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Products Added:",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  Text(
                    "${products.length}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categorySearchController,
              onChanged: (value) {
                setState(() {
                  categorySearchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search Categories...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredCategories.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      selectedCategory == filteredCategories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = filteredCategories[index];
                        itemSearchText = "";
                        itemSearchController.clear();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.blueAccent : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filteredCategories[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (selectedCategory.isNotEmpty)
              TextField(
                controller: itemSearchController,
                onChanged: (value) {
                  setState(() {
                    itemSearchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search Items in $selectedCategory...",
                  prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            if (selectedCategory.isNotEmpty)
              Text(
                "Items in $selectedCategory: ${filteredProducts.length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          filteredProducts[index].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Price: €${filteredProducts[index].price}"),
                              Text("Tax: ${filteredProducts[index].tax}"),
                            ],
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Qty: ${filteredProducts[index].quantity}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                sendBarcodeToAPI(
                                    filteredProducts[index].barCode ?? '');
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

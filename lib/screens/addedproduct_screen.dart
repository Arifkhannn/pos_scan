import 'package:flutter/material.dart';
import '../api/added_product_api.dart';

class AddedProductScreen extends StatefulWidget {
  const AddedProductScreen({super.key});

  @override
  State<AddedProductScreen> createState() => _AddedProductScreenState();
}

class _AddedProductScreenState extends State<AddedProductScreen> {
  late Future<List<dynamic>> _productListFuture;
  final AddedProductApi productApi = AddedProductApi();

  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _productListFuture = productApi.getAddedProducts();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await productApi.getAddedProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
      });
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
      _filteredProducts = _products;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _filteredProducts = _products;
    });
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _products;
      });
      return;
    }

    setState(() {
      _filteredProducts = _products
          .where((product) =>
              (product['name'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.5,
        toolbarHeight: 60,
        iconTheme: const IconThemeData(color: Colors.black),
        title: _isSearching
            ? TextField(
                onChanged: _searchProducts,
                autofocus: true,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              )
            : const Text(
                'Added Products',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              if (_isSearching) {
                _stopSearch();
              } else {
                _startSearch();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _productListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (_filteredProducts.isEmpty) {
            return const Center(
              child: Text(
                "No products found.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'https://www.incathlab.com/images/products/default_product.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Price: ${product['price'] ?? 'N/A'} EUR',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Quantity: ${product['quantity'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Barcode: ${product['barCode'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (product['tax'] != null)
                              Text(
                                'Tax: ${product['tax']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            if (product['category'] != null)
                              Text(
                                'Category: ${product['category']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

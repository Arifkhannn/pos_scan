import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pos_scan/API/login_api.dart';
import 'package:pos_scan/API/product_details_api.dart';
import 'package:pos_scan/Models/product_model.dart';
import 'package:pos_scan/main.dart';
import 'package:pos_scan/screens/add_product_screen.dart';
import 'package:pos_scan/screens/edit_product_screen.dart';
import 'package:pos_scan/screens/histories.dart';
import 'package:pos_scan/screens/history_screen.dart';
import 'package:pos_scan/screens/inventoryScreen.dart';
import 'package:pos_scan/screens/no_barcode.dart';
import 'package:pos_scan/screens/submit_screen.dart';
import 'package:pos_scan/screens/xy_report.dart';
import 'package:pos_scan/services/getAppKey.dart';
import 'package:pos_scan/services/google_Scan.dart';
import 'package:pos_scan/services/scan_services.dart';
import 'package:pos_scan/utils/sounds.dart';
import 'package:shared_preferences/shared_preferences.dart';

String homeBarCode = '';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final Scanner scanner = Scanner();
  final ProductDetailsApi productApi = ProductDetailsApi();
  Sounds welcome = Sounds();

  late AnimationController _sparkleController;
  String appKey = '';

  @override
  void initState() {
    _playWelcomeSoundOnce();
    _loadAppKey();
    super.initState();
    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  _loadAppKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedAppKey = prefs.getString('appKey');
    setState(() {
      appKey = storedAppKey ?? 'No App Key Found';
    });
  }

  Future<void> _playWelcomeSoundOnce() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSoundPlayed = prefs.getBool('isWelcomeSoundPlayed') ?? false;

    if (!isSoundPlayed) {
      welcome.playWelcomeSound();
      await prefs.setBool('isWelcomeSoundPlayed', true);
    }
  }

  Widget buildTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required AnimationController animation,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          double sparkleValue =
              (0.5 + animation.value * 0.5).clamp(0.5, 1.0);
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.blue.withOpacity(sparkleValue),
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
     appBar: AppBar(
  backgroundColor: Colors.grey[100], // Changed background color to blueGrey
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.menu, color: Color.fromARGB(255, 0, 0, 0)), // Changed icon color to white for contrast
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportsScreen(),
        ),
      );
    },
  ),
  title: const Text(
    'POS Infinity',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Colors.grey, // Changed text color to white for contrast
    ),
  ),
  centerTitle: true, // This property centers the title
),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 1,
                  children: [
                    buildTile(
                      icon: Icons.document_scanner_outlined,
                      label: 'Update Stock',
                      onTap: () async {
                        String result = await scanner.scanBarcode();
                        try {
                          Product productData =
                              await productApi.fetchProductData(result);
                          if (productData.barCode.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubmitScreen(
                                  product: productData,
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to load product data')),
                          );
                          if (globalStatusCode == 200) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Product Not Found !!',
                                  style: TextStyle(color: Colors.red),
                                ),
                                content: const Text(
                                  'The product does not exist. Would you like to add it?',
                                  style: TextStyle(fontSize: 15),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddProductScreen()),
                                      );
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      animation: _sparkleController,
                    ),
                    buildTile(
                      icon: Icons.edit_document,
                      label: 'Edit Product',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProductScreen(),
                          ),
                        );
                      },
                      animation: _sparkleController,
                    ),
                    buildTile(
                      icon: Icons.history,
                      label: 'History',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Histories(),
                          ),
                        );
                      },
                      animation: _sparkleController,
                    ),
                    buildTile(
                      icon: Icons.add_circle_outline,
                      label: 'Add Product',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddProductScreen(),
                          ),
                        );
                      },
                      animation: _sparkleController,
                    ),
                    buildTile(
                      icon: Icons.qr_code_2,
                      label: 'Non Barcode Product',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NoBarcode(),
                          ),
                        );
                      },
                      animation: _sparkleController,
                    ),
                    buildTile(
                      icon: Icons.inventory_rounded,
                      label: 'Inventory',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InventoryScreen(),
                          ),
                        );
                      },
                      animation: _sparkleController,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              appKey,
              style: TextStyle(
                  color: Colors.grey.withOpacity(0.2), fontSize: 20),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('All Rights Reserved'),
                  SizedBox(width: 4),
                  Icon(Icons.copyright_outlined, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'AUCTECH',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveStockUpdate(String productName, String quantity, String timestamp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, List<dynamic>> updatesMap = {};

  // Load existing updates
  final existingData = prefs.getString('stock_updates_map');
  if (existingData != null) {
    updatesMap = Map<String, List<dynamic>>.from(json.decode(existingData));
  }

  // Format the date
  String dateKey = timestamp.split('T')[0];

  // Add the update
  updatesMap.putIfAbsent(dateKey, () => []);
  updatesMap[dateKey]?.add('Product Name: $productName, Quantity: $quantity, Timestamp: $timestamp');

  // Save back to SharedPreferences
  await prefs.setString('stock_updates_map', json.encode(updatesMap));
}

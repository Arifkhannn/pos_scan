import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos_scan/services/getAppKey.dart';

class AddedProductApi {
  Future<List<dynamic>> getAddedProducts() async {
    try {
      String uniqueCode = await getAppKey();
      final url = Uri.parse('https://pos.dftech.in/pos/added-products');
      final response = await http.get(url, headers: {
        'Authorization': uniqueCode,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        print(response.body);
        if (data["status"] == true) {
          return data["products"] ?? [];
        } else {
          return [];
        }
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}

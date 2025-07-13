import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pos_scan/services/getAppKey.dart';

class EditProduct {
  static Future<int> editProduct(String barcode, String name, String category,
      String price, String tax) async {
    String uniqueCode = await getAppKey();
    final url = Uri.parse('https://pos.dftech.in/products/update-product');
    try {
      final Response = await http.post(url, headers: {
        'Authorization': uniqueCode
      }, body: {
        'barcode': barcode,
        'name': name,
        'price': price,
        'category': category,
        'tax': tax
      });
      print(barcode);
      print(name);
      print(category);
      print(price);
      print(tax);
      print(Response.body);
      if (Response.statusCode == 200) {
        return 200;
      } else {
        return 109;
      }
    } catch (e) {
      print(e);
      print('from catch block');
      return 109;
    }
  }
}

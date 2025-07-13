import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_scan/API/login_api.dart';
import 'package:pos_scan/Models/product_model.dart';
import 'package:pos_scan/screens/add_product_screen.dart';
import 'package:pos_scan/services/getAppKey.dart';
import 'package:pos_scan/services/unique_code_generator.dart';

String globalBarCode = '';

var globalStatusCode = 0;

class ProductDetailsApi {
  Future<Product> fetchProductData(String barcode) async {
    try {
      print('barcodeApiSend $barcode');
      String uniqueCode = await getAppKey();

      final response = await http.get(
        Uri.parse('https://pos.dftech.in/pos/product-by-barcode/$barcode'),
        headers: {
          'Authorization': uniqueCode,
        },
      );

      // Printing the response to debug
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final resjson = (json.decode(response.body));
      print(resjson["product"]);
      globalBarCode = barcode;

      if (response.statusCode == 200) {
        globalStatusCode = response.statusCode;
        print(
            '******************************************************************');
        // Printing the decoded product data for debugging
        print('Product Data: ${json.decode(response.body)}');
        var resJson = json.decode(response.body);
        // Access the "product" field from the response
        if (resJson['status'] == true && resJson['product'] != null) {
          final productData = resJson['product'];
          // Converting the "product" data into a Product object
          return Product.fromJson(productData);
        } else {
          print('invalid response structure');
          throw Exception('somethig went wrong');
        }
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  // submitting api

  Future<int> submitOrder(String barcode, int quantity) async {
    try {
      String uniqueCode = await getAppKey();
      final url =
          Uri.parse('https://pos.dftech.in/products/update-stock-quantity')
              .replace(
        queryParameters: {
          'product_barcode': barcode,
          'quantity': quantity.toString(),
          'application_id': uniqueCode
        },
      );
      print('url:$url');

      //  the GET request
      final response = await http.get(url, headers: {
        'Authorization': uniqueCode,
      });

      //  the response status
      if (response.statusCode == 200) {
        print('update stocks----${response.body}');
        print(response.statusCode);
        print('Order submitted successfully');
        return response.statusCode;
      } else {
        print('Failed to submit order. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting order: $e');
    }
    return 500;
  }

  // api call for regestring the app at the backend

  Future<int> registerApp(String code) async {
    try {
      final url = Uri.parse('http://192.168.29.206/POS/public/register-app')
          .replace(queryParameters: {'application_id': code});
      print('url:$url');
      final regisResponse = await http.get(url);
      if (regisResponse.statusCode == 200) {
        print(regisResponse.body);
        return 200;
      } else {
        return 100;
      }
    } catch (e) {
      print('there was an error--------$e');
      return 109;
    }
  }

  Future<int> addNewProduct(String? barCode, String name, String price,
      String quantity, String tax, String category) async {
    String uniqueCode = await getAppKey();
    try {
      final url = Uri.parse('https://pos.dftech.in/queue-product');

      /* final Map<String, String> body = {
        'barCode': barCode,
        'name': name,
        'price': price,
        'quantity': quantity,
      };*/

      final responseAddprouct = await http.post(url, headers: {
        'Authorization': uniqueCode
      }, body: {
         if (barCode != null && barCode.isNotEmpty) 'barCode': barCode,
        'name': name,
        'price': price,
        'quantity': quantity,
        'tax': tax,
        'category': category
      });

      if (responseAddprouct.statusCode == 200) {
        print(responseAddprouct.statusCode);
        print(responseAddprouct.body);
        return responseAddprouct.statusCode;
      }
      if (responseAddprouct.statusCode == 401) {
        print(responseAddprouct.statusCode);
        print(responseAddprouct.body);
        return responseAddprouct.statusCode;
      } else {
        print(responseAddprouct.statusCode);
        print(
            'somenthing went wrong--- check the api, this is from else block of try');
      }
    } catch (e) {
      print(e);
      return 109;
    }
    return 109;
  }
}

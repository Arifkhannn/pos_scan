import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NProduct {  // Changed class name
  final String? barCode;
  final String name;
  final String price;
  final String quantity;
  final String tax;
  final String category;

  NProduct({  // Changed constructor name
    this.barCode,
    required this.name,
    required this.price,
    required this.quantity,
    required this.tax,
    required this.category,
  });

  factory NProduct.fromJson(Map<String, dynamic> json) {  // Changed factory name
    return NProduct(  // Changed constructor call
      barCode: json['barCode'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      tax: json['tax'],
      category: json['category'],
    );
  }
}

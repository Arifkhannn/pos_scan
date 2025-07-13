class InventoryModel {
  final String? barCode;
  final String name;
  final String price;
  final String quantity;
  final String tax;
  final String category;

  InventoryModel({
    required this.barCode,
    required this.name,
    required this.price,
    required this.quantity,
    required this.tax,
    required this.category,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      barCode: json['barCode'], // Can be null, so no default value
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      quantity: json['quantity'] ?? '',
      tax: json['tax'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class Product {
  final String category;
  int? id;
  final String name;
  String barCode;
  //final String type;
  String? image;
  int? categoryId;
  final String price;
  String? cost;
  // final String? weight;
  // final String unit;
  final String quantity;
  // final int pos;
  String? salesDesc;
  //final String tags;
  final String tax;
  String? code;
  /* final String? addedBy;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;*/

  Product({
    required this.category,
    required this.barCode,
    this.id,
    required this.name,
    // required this.type,
    this.image,
    this.categoryId,
    required this.price,
    this.cost,
    // this.weight,
    // required this.unit,
    required this.quantity,
    // required this.pos,
    this.salesDesc,
    // required this.tags,
    required this.tax,
    this.code,
    // this.addedBy,
    // this.deletedAt,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      category: json['category'],
      barCode: json['barCode'],
     // id: json['id'],
      name: json['name'],
      // type: json['type'],
      image: json['image'],
      //categoryId: json['category_id'],
      price: json['price'],
     // cost: json['cost'],
      //  weight: json['weight'],
      // unit: json['unit'],
      quantity: json['quantity'],
      // pos: json['pos'],
      //salesDesc: json['sales_desc'],

      /// tags: json['tags'],
      tax: json['tax'],
      //code: json['code'],
      // addedBy: json['added_by'],
      // deletedAt: json['deleted_at'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
    );
  }
}

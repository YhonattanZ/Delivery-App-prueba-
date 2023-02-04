import 'dart:convert';

Product? productFromMap(String str) => Product.fromMap(json.decode(str));

String productToMap(Product? data) => json.encode(data!.toMap());

class Product {
  Product({
    this.id,
    this.name,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.idCategory,
    this.price,
    this.quantity,
  });

  String? id;
  String? name;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? idCategory;
  num? price;
  int? quantity;

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image1: json["image1"],
        image2: json["image2"],
        image3: json["image3"],
        idCategory: json["id_category"],
        price: json["price"],
        quantity: json["quantity"],
      );

  static List<Product> fromJsonList(List jsonList) {
    List<Product> toList = [];

    for (var item in jsonList) {
      Product product = Product.fromMap(item);
      toList.add(product);
    }
    return toList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "image1": image1,
        "image2": image2,
        "image3": image3,
        "id_category": idCategory,
        "price": price,
        "quantity": quantity,
      };
}

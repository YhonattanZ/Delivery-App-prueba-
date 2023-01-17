import 'dart:convert';

Category? categoryFromMap(String str) => Category.fromMap(json.decode(str));

String categoryToMap(Category? data) => json.encode(data!.toMap());

class Category {
  Category({
    this.id,
    this.name,
    this.description,
  });

  String? id;
  String? name;
  String? description;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  static List<Category> fromJsonList(List jsonList) {
    List<Category> toList = [];

    for (var item in jsonList) {
      Category category = Category.fromMap(item);
      toList.add(category);
    }
    return toList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

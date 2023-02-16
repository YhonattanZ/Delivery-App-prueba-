import 'dart:convert';

import 'package:app_delivery/src/models/models.dart';

Order orderFromMap(String str) => Order.fromMap(json.decode(str));

String orderToMap(Order data) => json.encode(data.toMap());

class Order {
  Order(
      {this.id,
      this.idClient,
      this.idDelivery,
      this.idAddress,
      this.status,
      this.lat,
      this.lng,
      this.timestamp,
      this.products,
      this.client,
      this.delivery,
      this.address});

  String? id;
  String? idClient;
  String? idDelivery;
  String? idAddress;
  String? status;
  double? lat;
  double? lng;
  int? timestamp;
  List<Product>? products = [];
  User? client;
  User? delivery;

  Address? address;

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"],
        idClient: json["id_client"],
        idDelivery: json["id_delivery"],
        idAddress: json["id_address"],
        status: json["status"],
        // ignore: unnecessary_type_check
        products: json["products"] != null
            ? List<Product>.from(json["products"].map(
                (model) => model is Product ? model : Product.fromMap(model)))
            : [],
        lat: json["lat"],
        lng: json["lng"],
        timestamp: json["timestamp"],
        client: json["client"] is String
            ? userFromJson(json["client"])
            : json["client"] is User
                ? json["client"]
                : User.fromJson(json["client"] ?? {}),
        delivery: json["delivery"] is String
            ? userFromJson(json["delivery"])
            : json["delivery"] is User
                ? json["delivery"]
                : User.fromJson(json["delivery"] ?? {}),

        address: json["address"] is String
            ? addressFromMap(json["address"])
            : json["address"] is Address
                ? json["address"]
                : Address.fromMap(json["address"] ?? {}),
      );

  static List<Order> fromJsonList(List jsonList) {
    List<Order> toList = [];

    for (var item in jsonList) {
      Order order = Order.fromMap(item);
      toList.add(order);
    }
    return toList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_client": idClient,
        "id_delivery": idDelivery,
        "id_address": idAddress,
        "status": status,
        "lat": lat,
        "lng": lng,
        "timestamp": timestamp,
        "products": products!
            .map((e) => e.toMap())
            .toList(), // products!.map((e) => e.toMap()).toList() quita el error Converting object to an encodable object failed
        "client": client,
        "address": address?.toMap(),
        "delivery": delivery
      };
}

import 'dart:convert';

Address addressFromMap(String str) => Address.fromMap(json.decode(str));

String addressToMap(Address data) => json.encode(data.toMap());

class Address {
  Address({
    this.id,
    this.address,
    this.neighborhood,
    this.idUser,
    this.lat,
    this.lng,
  });

  String? id;
  String? address;
  String? neighborhood;
  String? idUser;
  double? lat;
  double? lng;

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"],
        address: json["address"],
        neighborhood: json["neighborhood"],
        idUser: json["id_user"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  static List<Address> fromJsonList(List jsonList) {
    List<Address> toList = [];

    for (var item in jsonList) {
      Address address = Address.fromMap(item);
      toList.add(address);
    }
    return toList;
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "address": address,
        "neighborhood": neighborhood,
        "id_user": idUser,
        "lat": lat,
        "lng": lng,
      };
}

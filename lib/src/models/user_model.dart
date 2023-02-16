import 'dart:convert';

import 'package:app_delivery/src/models/models.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? password;
  String? id;
  String? sessionToken;
  //Para obtener los roles
  List<RolesUsuario>? roles = [];

  User(
      {this.email,
      this.name,
      this.lastname,
      this.phone,
      this.image,
      this.password,
      this.id,
      this.sessionToken,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    lastname = json['lastname'];
    phone = json['phone'];
    image = json['image'];
    password = json['password'];
    sessionToken = json['session_token'];
    roles = json['roles'] == null
        ? []
        : List<RolesUsuario>.from(
            json["roles"].map((model) => RolesUsuario.fromMap(model)));
  }

  static List<User> fromJsonList(List jsonList) {
    List<User> toList = [];

    for (var item in jsonList) {
      User user = User.fromJson(item);
      toList.add(user);
    }
    return toList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['lastname'] = lastname;
    data['phone'] = phone;
    data['image'] = image;
    data['password'] = password;
    data['id'] = id;
    data['session_token'] = sessionToken;
    data["roles"] = roles;
    return data;
  }
}

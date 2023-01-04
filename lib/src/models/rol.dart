import 'dart:convert';

RolesUsuario rolesUsuarioFromMap(String str) =>
    RolesUsuario.fromMap(json.decode(str));

String rolesUsuarioToMap(RolesUsuario data) => json.encode(data.toMap());

class RolesUsuario {
  String? id;
  String? name;
  String? image;
  String? route;

  RolesUsuario({
    this.id,
    this.name,
    this.image,
    this.route,
  });

  factory RolesUsuario.fromMap(Map<String, dynamic> json) => RolesUsuario(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        route: json["route"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "route": route,
      };
}

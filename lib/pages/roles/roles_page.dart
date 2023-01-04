import 'package:app_delivery/pages/roles/roles_controller.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

RolesController rolesCtrl = Get.put(RolesController());

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.2),
        child: ListView(
            //Realizamos primero una validacion para evitar errores
            children: rolesCtrl.user.roles != null
                ? rolesCtrl.user.roles!.map((RolesUsuario roles) {
                    return _cardRolUsuario(context, roles);
                  }).toList() // si viene null mostraremos un array vacion con : []
                : []),
      ),
    );
  }
}

Widget _cardRolUsuario(BuildContext context, RolesUsuario roles) {
  Size size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: () => rolesCtrl.goToPageRol(roles),
    child: Column(
      children: [
        Container(
          height: size.height * 0.10,
          margin: EdgeInsets.only(bottom: size.height * 0.010),
          child: FadeInImage(
            image: NetworkImage(roles.image!),
            fit: BoxFit.contain,
            fadeInDuration: const Duration(milliseconds: 50),
            placeholder: const AssetImage('assets/images/no-image.jpg'),
          ),
        ),
        Text(
          roles.name ?? '',
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: size.height * 0.010,
        )
      ],
    ),
  );
}

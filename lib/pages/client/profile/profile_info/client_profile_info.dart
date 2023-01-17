import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/profile/profile_info/client_profile_info_controller.dart';
import 'package:app_delivery/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

ClientProfileInfoController infoController =
    Get.put(ClientProfileInfoController());

class ClientProfileInfoPage extends StatelessWidget {
  const ClientProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          _backgroundColor(context),
          _CreateNewAccountBox(context),
          Column(
            children: [
              _LogoCover(context),
              SizedBox(
                height: size.height * 0.010,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

Widget _CreateNewAccountBox(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Stack(children: [
    SafeArea(
      child: Container(
        alignment: Alignment.topRight,
        child: IconButton(
          padding: EdgeInsets.only(right: size.width * 0.080),
          iconSize: 30,
          icon: const Icon(Icons.logout_outlined),
          color: Colors.white,
          onPressed: () {
            infoController.signOut();
          },
        ),
      ),
    ),
    //Container blanco
    Container(
      margin: EdgeInsets.only(top: size.height * 0.25),
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black38, spreadRadius: 3, blurRadius: 10)
      ], color: Colors.white, borderRadius: BorderRadius.circular(40)),
      width: double.infinity,
      height: size.height * 0.5,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height * 0.020),
            child: Text('Mi Perfil',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          SizedBox(height: size.height * 0.030),
          UserInfoListTile(
            size: size,
            style: GoogleFonts.lato(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
            icon: const Icon(Icons.person, size: 30),
            iconColor: kPrimaryColor,
            info: '${infoController.user.value.name ?? ''} '
                '${infoController.user.value.lastname ?? ''}',
            subtitleInfo: 'Nombre',
          ),
          UserInfoListTile(
            size: size,
            style: GoogleFonts.lato(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
            icon: const Icon(Icons.email, size: 30),
            iconColor: kPrimaryColor,
            info: infoController.user.value.email!,
            subtitleInfo: 'Email',
          ),
          UserInfoListTile(
            size: size,
            style: GoogleFonts.lato(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
            icon: const Icon(
              Icons.whatsapp,
              size: 30,
            ),
            iconColor: kPrimaryColor,
            info: infoController.user.value.phone!,
            subtitleInfo: 'Numero de contacto',
          ),
          SizedBox(height: size.height * 0.05),
          SizedBox(
            height: size.height * 0.07,
            width: size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                infoController.updatedatos();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 43, 136, 134),
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Actualiza tus datos',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.010),
        ],
      ),
    ),
  ]);
}

Widget _backgroundColor(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.30,
    color: kPrimaryColor,
  );
}

Widget _LogoCover(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return SafeArea(
      child: Container(
    margin: EdgeInsets.only(top: size.height * 0.030),
    child: Center(
      child: CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 70,
          backgroundImage: infoController.user.value.image != null
              ? NetworkImage(infoController.user.value.image!)
              : const AssetImage('assets/images/delivery 2.png')
                  as ImageProvider),
    ),
  ));
}

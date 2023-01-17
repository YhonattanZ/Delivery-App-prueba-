import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/update/update_info/client_profile_update_controller.dart';
import 'package:app_delivery/widgets/sign_up_forms.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

ClientProfileUpdateController updateController =
    Get.put(ClientProfileUpdateController());

class ClientProfileUpdatePage extends StatelessWidget {
  const ClientProfileUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: IconButton(
        padding: EdgeInsets.only(left: size.width * 0.060),
        iconSize: 30,
        icon: const Icon(Icons.arrow_back_rounded),
        color: Colors.white,
        onPressed: () => Get.back(),
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
            child: Text('Actualiza tus datos',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          SizedBox(
            height: size.height * 0.04,
          ),
          SignUpForms(
              controller: updateController.nameCtrl,
              obstext: false,
              formTitle: 'Nombre',
              formIcon: Icon(
                Icons.person,
                color: kPrimaryColor,
              ),
              keyboardType: TextInputType.name),
          SizedBox(
            height: size.height * 0.03,
          ),
          SignUpForms(
              controller: updateController.lastnameCtrl,
              obstext: false,
              formTitle: 'Apellido',
              formIcon: Icon(Icons.person_outline, color: kPrimaryColor),
              keyboardType: TextInputType.name),
          SizedBox(
            height: size.height * 0.03,
          ),
          SignUpForms(
              controller: updateController.phoneCtrl,
              obstext: false,
              formTitle: 'Numero de telefono',
              formIcon: Icon(Icons.phone, color: kPrimaryColor),
              keyboardType: TextInputType.phone),
          SizedBox(
            height: size.height * 0.05,
          ),
          actualizarButton(context),
        ],
      ),
    ),
  ]);
}

Widget _backgroundColor(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.30,
    color: const Color.fromARGB(255, 43, 136, 134),
  );
}

Widget actualizarButton(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        height: size.height * 0.07,
        width: size.width * 0.6,
        child: ElevatedButton(
          onPressed: () {
            updateController.updateUser(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 43, 136, 134),
            shape: const StadiumBorder(),
          ),
          child: Text(
            'Actualizar',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}

Widget _LogoCover(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return SafeArea(
    child: Container(
      margin: EdgeInsets.only(top: size.height * 0.030),
      alignment: Alignment.topCenter,
      child: GestureDetector(
          onTap: () => updateController.showAlertDialog(context),
          child: GetBuilder<ClientProfileUpdateController>(
              builder: (value) => CircleAvatar(
                    backgroundImage: updateController.imageFile != null
                        ? FileImage(updateController.imageFile!)
                        : updateController.user.image != null
                            ? NetworkImage(updateController.user.image!)
                            : const AssetImage('assets/images/no-image.jpg')
                                as ImageProvider,
                    radius: 60,
                    backgroundColor: Colors.white,
                  ))),
    ),
  );
}

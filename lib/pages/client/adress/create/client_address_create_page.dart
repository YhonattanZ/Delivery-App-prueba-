import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/client/adress/create/client_address_create_controller.dart';
import 'package:app_delivery/widgets/sign_up_forms.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientAddressCreatePage extends StatelessWidget {
  ClientAddressCreatePage({super.key});

  ClientAddressCreateController addressCreateController =
      Get.put(ClientAddressCreateController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(children: [
          _backgroundColor(context),
          _CreateNewAddressBox(context),
          Column(
            children: [
              _mapIcon(context),
              const SizedBox(height: 10),
              Text(
                'Agregar nueva dirección',
                style: GoogleFonts.lato(fontSize: 22, color: Colors.white),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

Widget _mapIcon(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return SafeArea(
      child: Container(
    margin: EdgeInsets.only(top: size.height * 0.040),
    child: const Center(
        child: Icon(FontAwesomeIcons.mapLocationDot,
            color: Colors.white, size: 90)),
  ));
}

Widget _CreateNewAddressBox(BuildContext context) {
  final size = MediaQuery.of(context).size;
  ClientAddressCreateController addressCreateController =
      Get.put(ClientAddressCreateController());

  return Stack(children: [
    SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        child: IconButton(
          padding: EdgeInsets.only(left: size.width * 0.080),
          iconSize: 30,
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {},
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
          SizedBox(
            height: size.height / 13,
          ),
          SignUpForms(
              autofocus: false,
              controller: addressCreateController.addressController,
              obstext: false,
              formTitle: 'Dirección',
              formIcon: const Icon(
                FontAwesomeIcons.locationDot,
                color: kSecondaryColor,
              ),
              keyboardType: TextInputType.text),
          SizedBox(
            height: size.height * 0.030,
          ),
          SignUpForms(
              autofocus: false,
              obstext: false,
              controller: addressCreateController.neighborhoodController,
              formTitle: 'Urbanización',
              formIcon: const Icon(
                FontAwesomeIcons.city,
                color: kSecondaryColor,
              ),
              keyboardType: TextInputType.text),
          SizedBox(
            height: size.height * 0.030,
          ),
          SignUpForms(
              obstext: false,
              onTap: () {
                addressCreateController.openGoogleMaps(context);
              },
              formTitle: 'Punto de referencia',
              controller: addressCreateController.referencePointController,
              autofocus: false,
              focusNode: AlwaysDisabledFocusNode(),
              formIcon: const Icon(
                FontAwesomeIcons.mapLocation,
                color: kSecondaryColor,
              ),
              keyboardType: TextInputType.text),
          SizedBox(height: size.height / 20),
          SizedBox(
            height: size.height * 0.07,
            width: size.width * 0.6,
            child: ElevatedButton(
              onPressed: () {
                addressCreateController.createAddress();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Crear dirección',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    ),
  ]);
}

Widget _backgroundColor(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.30,
    color: kSecondaryColor,
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

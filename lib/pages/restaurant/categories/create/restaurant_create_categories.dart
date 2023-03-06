import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/restaurant/categories/create/restaurant_create_controller.dart';
import 'package:app_delivery/widgets/sign_up_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

RestaurantCreateCategoryController _createCategoryCtrl =
    Get.put(RestaurantCreateCategoryController());

class RestaurantCategoriesCreatePage extends StatelessWidget {
  const RestaurantCategoriesCreatePage({super.key});

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
            margin: EdgeInsets.only(top: size.height * 0.030),
            child: Text('Añade la información',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 15),
            alignment: Alignment.center,
            child: SignUpForms(
                autofocus: true,
                controller: _createCategoryCtrl.nameCtrl,
                obstext: false,
                formTitle: 'Nombre',
                formIcon: Icon(
                  Icons.description,
                  color: kPrimaryColor,
                ),
                keyboardType: TextInputType.name),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SignUpForms(
              autofocus: true,
              controller: _createCategoryCtrl.descriptionCtrl,
              obstext: false,
              lines: 3,
              formTitle: 'Descripcion',
              formIcon: Icon(Icons.info, color: kPrimaryColor),
              keyboardType: TextInputType.text),
          SizedBox(
            height: size.height * 0.03,
          ),
          actualizarCategoriaButton(context),
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

Widget actualizarCategoriaButton(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: size.height / 50),
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width * 0.6,
          child: ElevatedButton(
            onPressed: () {
              _createCategoryCtrl.createCategory();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 43, 136, 134),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Crear categoria',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _LogoCover(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return Container(
      margin: EdgeInsets.only(top: size.height / 25),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Image.asset(
            'assets/images/menu categoria.png',
            width: 200,
          ),
          SizedBox(height: size.height * 0.015),
          Text('Crea tu nueva categoría de productos',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              )),
        ],
      ));
}

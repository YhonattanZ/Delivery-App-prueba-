import 'dart:io';

import 'package:app_delivery/constants/constants.dart';
import 'package:app_delivery/pages/restaurant/products/restaurant_product_create_controller.dart';
import 'package:app_delivery/src/models/category.dart';
import 'package:app_delivery/widgets/sign_up_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

RestaurantCreateProductController _createProductCtrl =
    Get.put(RestaurantCreateProductController());

class RestaurantProductCreatePage extends StatelessWidget {
  const RestaurantProductCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Obx(() => Stack(children: [
                  _backgroundColor(context),
                  _CreateNewAccountBox(context),
                  Column(
                    children: [
                      _LogoCover(context),
                    ],
                  ),
                ]))));
  }
}

Widget _CreateNewAccountBox(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Stack(children: [
    //Container blanco
    Container(
      margin: EdgeInsets.only(top: size.height * 0.22),
      decoration: BoxDecoration(boxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black38, spreadRadius: 3, blurRadius: 10)
      ], color: Colors.white, borderRadius: BorderRadius.circular(40)),
      width: double.infinity,
      height: size.height * 0.65,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height * 0.020),
            child: Text('Añade la información',
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height / 40),
            alignment: Alignment.center,
            child: SignUpForms(
                autofocus: true,
                controller: _createProductCtrl.nameCtrl,
                obstext: false,
                formTitle: 'Nombre',
                formIcon: const Icon(
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
              controller: _createProductCtrl.descriptionCtrl,
              obstext: false,
              lines: 3,
              formTitle: 'Descripcion',
              formIcon: const Icon(Icons.info, color: kPrimaryColor),
              keyboardType: TextInputType.text),
          SizedBox(
            height: size.height * 0.03,
          ),
          SignUpForms(
              autofocus: true,
              controller: _createProductCtrl.priceCtrl,
              obstext: false,
              lines: 1,
              formTitle: 'Precio',
              formIcon: const Icon(Icons.attach_money, color: kPrimaryColor),
              keyboardType: TextInputType.number),
          _dropDownCategories(_createProductCtrl.categories),
          SizedBox(
            height: size.height * 0.012,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GetBuilder<RestaurantCreateProductController>(
                builder: (value) =>
                    _imagecard(context, _createProductCtrl.imageFile1, 1)),
            SizedBox(
              width: size.width * 0.015,
            ),
            GetBuilder<RestaurantCreateProductController>(
                builder: (value) =>
                    _imagecard(context, _createProductCtrl.imageFile2, 2)),
            SizedBox(
              width: size.width * 0.015,
            ),
            GetBuilder<RestaurantCreateProductController>(
                builder: (value) =>
                    _imagecard(context, _createProductCtrl.imageFile3, 3)),
          ]),
          Text('Agrega las imagenes del producto',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey)),
          actualizarCategoriaButton(context),
        ],
      ),
    ),
  ]);
}

List<DropdownMenuItem<String>> _dropDownitem(List<Category> categories) {
  List<DropdownMenuItem<String>> list = [];
  for (var item in categories) {
    list.add(DropdownMenuItem(
        value: item.id,
        child: Text(
          item.name.toString(),
          style: GoogleFonts.lato(fontSize: 18),
        )));
  }
  return list;
}

Widget _dropDownCategories(List<Category> categories) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 70),
    child: DropdownButton(
        underline: Container(
            alignment: Alignment.centerRight,
            child:
                const Icon(Icons.arrow_drop_down_circle, color: kPrimaryColor)),
        elevation: 2,
        isExpanded: true,
        hint: Text('Selecciona la categoria',
            style: GoogleFonts.lato(color: Colors.grey, fontSize: 16)),
        items: _dropDownitem(categories),
        value: _createProductCtrl.idCategory.value == ''
            ? null
            : _createProductCtrl.idCategory.value,
        onChanged: (value) {
          _createProductCtrl.idCategory.value = value.toString();
        }),
  );
}

Widget _imagecard(BuildContext context, File? imageFile, int number) {
  return GestureDetector(
      onTap: () {
        _createProductCtrl.showAlertDialog(context, number);
      },
      child: Card(
          elevation: 2,
          child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.2,
              child: imageFile != null
                  ? Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image:
                          AssetImage('assets/images/image landscape.png')))));
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
        margin: EdgeInsets.only(top: size.height / 60),
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width * 0.6,
          child: ElevatedButton(
            onPressed: () {
              _createProductCtrl.createProduct(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 43, 136, 134),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Crear producto',
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

  return SafeArea(
    child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/box.jpg'),
            ),
            Text('Crea tu nuevo producto',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                )),
          ],
        )),
  );
}

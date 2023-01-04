import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/pages/home_page/home_controller.dart';
import 'package:app_delivery/pages/home_page/home_page.dart';
import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RegisterController extends GetxController {
  TextEditingController EmailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController PhoneCtrl = TextEditingController();
  TextEditingController NameCtrl = TextEditingController();
  TextEditingController LastnameCtrl = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  //Seleccionar imagenes
  ImagePicker picker = ImagePicker();
  File? imageFile;
  void goToLoginPage() {
    Get.toNamed('/login');
  }

  void goToClientPage() {
    Get.offNamedUntil('/client/products/list', (route) => false);
  }

// TODO: VALIDAR CREDENCIALES ejemplo : Email no valido etc...

  void registerUser(BuildContext context) async {
    String email = EmailCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    String phoneNum = PhoneCtrl.text.trim();
    String username = NameCtrl.text;
    String lastname = LastnameCtrl.text;

    print(
        'Email: $email, Password: $password, PhoneNumber: $phoneNum, Name: $username, LastName: $lastname');
    if (isValidForm(context, email, username, lastname, password, phoneNum)) {
      ProgressDialog progressDialog = ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando el usuario');
      User user = User(
        email: email,
        name: username,
        lastname: lastname,
        phone: phoneNum,
        password: password,
      );

      Stream stream = await usersProvider.createUserWithImage(user, imageFile!);
      stream.listen((res) {
        ResponseApi responseApi = ResponseApi.fromMap(json.decode(res));

        if (responseApi.success == true) {
          GetStorage()
              .write('user', responseApi.data); //Guardar datos de la sesion
          goToClientPage();
          print('Usuario ID: ${responseApi.data}');
        } else {
          Get.snackbar('Registro fallido', responseApi.message ?? '');
        }
      });
      Get.snackbar(
          'Ya puedes iniciar sesion', 'Tu cuenta se ha registrado con exito');
    }
  }

  bool isValidForm(BuildContext context, String email, String username,
      String password, String phoneNum, String lastname) {
    if (email.isEmpty &&
        username.isEmpty &&
        password.isEmpty &&
        phoneNum.isEmpty &&
        lastname.isEmpty) {
      Get.snackbar(
          'Los campos no pueden estar vacios', 'Ingrese los datos solicitados');
      return false;
    }
    if (imageFile == null) {
      Get.snackbar(
          'Formulario no valido', 'Debes seleccionar una foto de perfil');
      return false;
    }
    return true;
  }

  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text('Galeria'),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: const Text('Camara'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona una opcion'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}

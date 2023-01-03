import 'dart:io';

import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
// TODO: VALIDAR CREDENCIALES ejemplo : Email no valido etc...

  void registerUser() async {
    String email = EmailCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    String phoneNum = PhoneCtrl.text.trim();
    String username = NameCtrl.text;
    String lastname = LastnameCtrl.text;
    print(
        'Email: $email, Password: $password, PhoneNumber: $phoneNum, Name: $username, LastName: $lastname');
    if (isValidForm(email, username, lastname, password, phoneNum)) {
      User user = User(
        email: email,
        name: username,
        lastname: lastname,
        phone: phoneNum,
        password: password,
      );

      Response res = await usersProvider.register(user);

      print('Response: ${res.body}');
      Get.snackbar(
          'Ya puedes iniciar sesion', 'Tu cuenta se ha registrado con exito');
    }
  }

  bool isValidForm(String email, String username, String password,
      String phoneNum, String lastname) {
    if (email.isEmpty &&
        username.isEmpty &&
        password.isEmpty &&
        phoneNum.isEmpty &&
        lastname.isEmpty) {
      Get.snackbar(
          'Los campos no pueden estar vacios', 'Ingrese los datos solicitados');
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

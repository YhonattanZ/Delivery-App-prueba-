import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/response_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage() {
    Get.toNamed('/register');
  }

  void goToHomePage() {
    Get.offNamedUntil('/login', (route) => false);
  }

  void login() async {
    String email = emailCtrl.text.trim();
    String password = passwordCtrl.text.trim();
    print('Email: $email, Password: $password');

    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      print('Response api: ${responseApi.toMap()}');

      if (responseApi.success == true) {
        GetStorage()
            .write('user', responseApi.data); //Guardar datos de la sesion
        goToHomePage();
      } else {
        Get.snackbar('Login fallido', responseApi.message ?? '');
      }
    }
  }

  bool isValidForm(String email, String password) {
    if (email.isEmpty) {
      Get.snackbar('El campo email esta vacio', 'Debes ingresar un email');
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no valido', 'Debes ingresar un email valido');
      return false;
    }

    if (password.isEmpty) {
      Get.snackbar(
          'El campo password esta vacio', 'Debes ingresar una contrasena ');
      return false;
    }
    return true;
  }
}

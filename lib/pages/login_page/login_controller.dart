import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  void goToRegisterPage() {
    Get.offNamedUntil('/register', (route) => false);
  }

  void goToHomePage() {
    Get.offNamedUntil('/home', (route) => false);
  }

  void goToRolesPage() {
    Get.offNamedUntil('/roles', (route) => false);
  }

  void goToClientProductPage() {
    Get.offNamedUntil('/client/products/list', (route) => false);
  }

  void login() async {
    String email = emailCtrl.text.trim();
    String password = passwordCtrl.text.trim();

    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);
      print('Response api: ${responseApi.toMap()}');

      if (responseApi.success == true) {
        GetStorage()
            .write('user', responseApi.data); //Guardar datos de la sesion
        User user = User.fromJson(GetStorage().read('user') ?? {});

        if (user.roles!.length > 1) {
          goToRolesPage();
        } else {
          goToClientProductPage();
        }
        //  goToHomePage();

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

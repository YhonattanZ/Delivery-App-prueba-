import 'dart:convert';

import 'dart:io';

import 'package:app_delivery/pages/client/profile/profile_info/client_profile_info_controller.dart';
import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ClientProfileUpdateController extends GetxController {
  User user = User.fromJson(GetStorage().read('user'));

  ClientProfileInfoController infoController = Get.find();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastnameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;
  UsersProvider provider = UsersProvider();

  ClientProfileUpdateController() {
    nameCtrl.text = user.name ?? '';
    lastnameCtrl.text = user.lastname ?? '';
    phoneCtrl.text = user.phone ?? '';
  }

  bool isValidForm(
      BuildContext context, String username, String phone, String lastname) {
    if (username.isEmpty && phone.isEmpty && lastname.isEmpty) {
      Get.snackbar(
          'Los campos no pueden estar vacios', 'Ingrese los datos solicitados');
      return false;
    }

    return true;
  }

  void updateUser(BuildContext context) async {
    String phone = phoneCtrl.text.trim();
    String name = nameCtrl.text;
    String lastname = lastnameCtrl.text;

    if (isValidForm(context, name, lastname, phone)) {
      User myuser = User(
          id: user.id,
          name: name,
          lastname: lastname,
          phone: phone,
          sessionToken: user.sessionToken);

      if (imageFile == null) {
        ResponseApi responseApi = await provider.updateWithoutImage(myuser);

        if (responseApi.success == true) {
          GetStorage().write('user', responseApi.data);
          infoController.user.value = User.fromJson(GetStorage().read('user'));
          Get.snackbar(
              'Actualizacion satisfactoria', 'Se han actualizado tus datos');
          print('Update sin imagen: ${responseApi.data}');
        }
      } else {
        Stream stream = await provider.UpdateWithImage(myuser, imageFile!);
        stream.listen((response) {
          ResponseApi responseApi = ResponseApi.fromJson(json.decode(response));
          print('Update con imagen: ${responseApi.data}');

          if (responseApi.success == true) {
            infoController.user.value =
                User.fromJson(GetStorage().read('user') ?? {});
            Get.snackbar('Se ha actualizado la informacion',
                'Datos de usuario actualizados');
          }
        });
      }
    }
  }

//Seleccionar Galeria o Camara para actualizar imagen de usuario
  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget? galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery);
      },
      child: const Text('Galeria'),
    );
    Widget? cameraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera);
      },
      child: const Text('Camara'),
    );

    AlertDialog? alertDialog = AlertDialog(
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

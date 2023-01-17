import 'package:app_delivery/providers/categories_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateCategoryController extends GetxController {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();

  void clearForm() {
    nameCtrl.text = '';
    descriptionCtrl.text = '';
  }

  void createCategory() async {
    String nombre = nameCtrl.text;
    String descripcion = descriptionCtrl.text;

    if (nombre.isNotEmpty && descripcion.isNotEmpty) {
      Category category = Category(name: nombre, description: descripcion);

      ResponseApi responseApi =
          await _categoriesProvider.createCategory(category);
      Get.snackbar('Proceso terminado', responseApi.message ?? '');
      if (responseApi.success == true) {}
      //Si es true, se limpiaran los campos para crear otras nuevas categorias
      clearForm();
    } else {
      Get.snackbar('Formulario invalido',
          'Debes rellenar todos los formularios para crear una nueva categoria');
    }
  }
}

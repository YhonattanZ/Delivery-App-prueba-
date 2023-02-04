import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/providers/categories_provider.dart';
import 'package:app_delivery/providers/products_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class RestaurantCreateProductController extends GetxController {
  RestaurantCreateProductController() {
    getCategories();
  }

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();

  var idCategory = ''.obs;
  List<Category> categories = <Category>[].obs;
  ProductProvider productProvider = ProductProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  final CategoriesProvider _categoriesProvider = CategoriesProvider();

  void getCategories() async {
    var result = await _categoriesProvider.getAllCategory();
    categories.clear();
    categories.addAll(result);
  }

  void clearForm() {
    nameCtrl.text = '';
    descriptionCtrl.text = '';
    priceCtrl.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory.value = '';
    update();
  }

  void createProduct(BuildContext context) async {
    String nombre = nameCtrl.text;
    String descripcion = descriptionCtrl.text;
    String price = priceCtrl.text;
    print('NAME:$nombre');
    print('DESCRIPTION: $descripcion');
    print('PRICE:$price');
    print('ID CATEGORY:$idCategory');

    if (isValidForm(nombre, price, descripcion)) {
      Product product = Product(
          name: nombre,
          description: descripcion,
          price: double.parse(price),
          idCategory: idCategory.value);

      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);
      Stream stream = await productProvider.create(product, images);
      stream.listen((event) {
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(event));
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        if (responseApi.success == true) {
          clearForm();
        } else {
          Get.snackbar('Un error ha ocurrido', responseApi.message ?? '');
        }
      });
    }
  }

  bool isValidForm(String name, String price, String description) {
    if (name.isEmpty && price.isEmpty && description.isEmpty) {
      Get.snackbar(
          'Formulario invalido', 'Debe rellenar los formularios correctamente');
      return false;
    }
    if (idCategory == null) {
      Get.snackbar('Formulario invalido', 'Por favor seleccionar la categoria');
      return false;
    }
    if (imageFile1 == null) {
      Get.snackbar('Formulario invalido', 'Por favor seleccionar la imagen 1');
      return false;
    }
    if (imageFile2 == null) {
      Get.snackbar('Formulario invalido', 'Por favor seleccionar la imagen 2');
      return false;
    }
    if (imageFile3 == null) {
      Get.snackbar('Formulario invalido', 'Por favor seleccionar la imagen 3');
      return false;
    }
    return true;
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      if (numberFile == 1) {
        imageFile1 = File(image.path);
      } else if (numberFile == 2) {
        imageFile2 = File(image.path);
      } else if (numberFile == 3) {
        imageFile3 = File(image.path);
      }
      update();
    }
  }

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.gallery, numberFile);
      },
      child: const Text('Galeria'),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () {
        Get.back();
        selectImage(ImageSource.camera, numberFile);
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

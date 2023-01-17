import 'dart:convert';

import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesProvider extends GetConnect {
  String url = Environment.API_URL + 'api/categories';

  final User _user = User.fromJson(GetStorage().read('user') ?? {});

//Listar categorias
  Future<List<Category>> getAllCategory() async {
    Response res = await get('$url/getAll', headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<Category> categories = Category.fromJsonList(res.body["data"]);

    return categories;
  }

//Crear categorias
  Future<ResponseApi> createCategory(Category category) async {
    Response res = await post('$url/create', category.toMap(), headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
    return responseApi;
  }
}

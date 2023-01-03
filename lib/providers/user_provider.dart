import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:get/get.dart';

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  Future<Response> register(User user) async {
    Response res = await post('$url/create', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return res;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response res = await post(
        '$url/login', {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});
    if (res.body == null) {
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromMap(res.body);
    return responseApi;
  }
}

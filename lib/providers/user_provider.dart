import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
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

//Sin GETX
  Future<Stream> createUserWithImage(User user, File fileImage) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile('image',
        http.ByteStream(fileImage.openRead().cast()), await fileImage.length(),
        filename: basename(fileImage.path)));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

//Con GETX
  Future<ResponseApi> createUserWithImageGetX(User user, File fileImage) async {
    FormData form = FormData({
      'image': MultipartFile(fileImage, filename: basename(fileImage.path)),
      'user': json.encode(user)
    });
    Response response = await post('$url/createWithImage', form);

    if (response.body == null) {
      Get.snackbar('Error en la peticion', 'No se pudo crear el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromMap(response.body);
    return responseApi;
  }
}

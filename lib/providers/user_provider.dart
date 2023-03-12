// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';

import 'package:get/get.dart';

class UsersProvider extends GetConnect {
  String url = '${Environment.API_URL}api/users';

  User sessionUser = User.fromJson(GetStorage().read('user') ?? {});
  Future<Response> register(User user) async {
    Response res = await post('$url/create', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return res;
  }

//Listar categorias
  Future<List<User>> findDeliveryMen() async {
    Response res = await get('$url/findDeliveryMen', headers: {
      'Content-Type': 'application/json',
      'Authorization': sessionUser.sessionToken ?? ''
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<User> user = User.fromJsonList(res.body);

    return user;
  }

//Actualizar sin cambiar la imagen
  Future<ResponseApi> updateWithoutImage(User user) async {
    //Peticion PUT para actualizar los datos
    Response res =
        await put('$url/updateWithoutImage', user.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': sessionUser.sessionToken ?? ''
    });

    if (res.body == null) {
      Get.snackbar(
          'Fallo al actualizar los datos', 'Hubo un error en el servidor');
      return ResponseApi();
    }
    if (res.statusCode == 401) {
      Get.snackbar('No autorizado para realizar la peticion',
          'Hubo un error en la autenticacion');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(res.body);

    return responseApi;
  }

//Actualizar sin cambiar la imagen
  Future<ResponseApi> updateNotificationToken(String id, String token) async {
    //Peticion PUT para actualizar los datos
    Response res = await put('$url/updateNotificationToken', {
      'id': id,
      'token': token
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': sessionUser.sessionToken ?? ''
    });

    if (res.body == null) {
      Get.snackbar(
          'Fallo al actualizar los datos', 'Hubo un error en el servidor');
      return ResponseApi();
    }
    if (res.statusCode == 401) {
      Get.snackbar('No autorizado para realizar la peticion',
          'Hubo un error al actualizar el token');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(res.body);

    return responseApi;
  }

  Future<ResponseApi> login(String email, String password) async {
    Response res = await post(
        '$url/login', {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});
    if (res.body == null) {
      Get.snackbar('Error', 'No se pudo realizar la peticion');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
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

//Actualizar datos incluyendo la imagen
  Future<Stream> UpdateWithImage(User user, File fileImage) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = sessionUser.sessionToken ?? '';
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
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

User user = User.fromJson(GetStorage().read('user') ?? {});

class ProductProvider extends GetConnect {
  Future<Stream> create(Product product, List<File> images) async {
//Listar categorias
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/products/create');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = user.sessionToken ?? '';
    for (int i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)));
    }

    request.fields['product'] = jsonEncode(product.toMap());
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<List<Product>> findByCategory(String idCategory) async {
    Response res = await get(
        '${Environment.API_URL}api/products/findByCategory/$idCategory',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': user.sessionToken ?? ''
        });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(res.body["data"]);

    return products;
  }
}

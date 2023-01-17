import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProductProvider extends GetConnect {
  Future<Stream> create(Product product, List<File> images) async {
    User user = User.fromJson(GetStorage().read('user') ?? {});

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
}

import 'package:app_delivery/environment/environment.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressProvider extends GetConnect {
  String url = Environment.API_URL + 'api/address';

  final User _user = User.fromJson(GetStorage().read('user') ?? {});

  //Listar direcciones
  Future<List<Address>> findByUser(String idUser) async {
    Response res = await get('$url/findByUser/$idUser', headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    if (res.statusCode == 401) {
      Get.snackbar('Peticion negada', 'No posee autorizacion');
      return [];
    }
    List<Address> address = Address.fromJsonList(res.body);
    return address;
  }

//Crear categorias
  Future<ResponseApi> createAdress(Address address) async {
    Response res = await post('$url/create', address.toMap(), headers: {
      'Content-Type': 'application/json',
      'Authorization': _user.sessionToken ?? ''
    });
    ResponseApi responseApi = ResponseApi.fromJson(res.body);
    return responseApi;
  }
}
